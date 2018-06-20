# YNAB API Test

Today, [You Need A Budget](https://www.youneedabudget.com/) [announced a public API](https://www.youneedabudget.com/introducing-ynabs-api/). This is a game changer.

To begin, I'd simply like to get the data for the current budget categories and present them in a CSV with the following format:  

Category   | Budgeted | Spent | Balance
-----------|----------|-------|---------
Description| $        | $     | $

To be extra neck-beardy, I'm going to try and do this using `curl` and `jq`.

# Flow

Fortunately, the `/budgets/{budget_id}/categories` endpoint lets us get that data with a single parameter (`budget_id`), which you can obtain from the `/budgets` endpoint.

So, first, we call the `budget` endpoint, capture the id from `/budgets` using .data.budgets[0].id.

``` sh
budget_id=$(curl -X GET "https://api.youneedabudget.com/v1/budgets" -H  "accept: application/json" -H  "Authorization: Bearer $YNAB_API_KEY" | jq -r .data.budgets[0].id);
```

Then we can get the budget categories using:
``` sh
curl -X GET "https://api.youneedabudget.com/v1/budgets/$budget_id/categories" -H  "accept: application/json" -H  "Authorization: Bearer $YNAB_API_KEY"
```

Now, the fun part:
``` sh
jq -r '.data | .category_groups | .[] | .categories[] | [.name, .budgeted, .activity, .balance] | @csv'
```

Putting it all together:
``` sh
budget_id=$( \
  curl -s -X GET "https://api.youneedabudget.com/v1/budgets" -H  "accept: application/json" -H  "Authorization: Bearer $YNAB_API_KEY" | jq -r .data.budgets[0].id); \
curl -s -X GET "https://api.youneedabudget.com/v1/budgets/$budget_id/categories" -H  "accept: application/json" -H  "Authorization: Bearer $YNAB_API_KEY" | \
jq -r '.data | .category_groups | .[] | .categories[] | [.name, .budgeted, .activity, .balance] | @csv'
```

Voila! A nice csv file.

## Usage

Get token from YNAB. Install `curl` and `jq`.

Run `export YNAB_API_KEY=[key]; bash get_categories.sh`.

Done.

## License

CC0
