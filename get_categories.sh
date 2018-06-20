budget_id=$( \
curl -s -X GET "https://api.youneedabudget.com/v1/budgets" -H  "accept: application/json" -H  "Authorization: Bearer $YNAB_API_KEY" | jq -r .data.budgets[0].id); \
curl -s -X GET "https://api.youneedabudget.com/v1/budgets/$budget_id/categories" -H  "accept: application/json" -H  "Authorization: Bearer $YNAB_API_KEY" | \
jq -r '.data | .category_groups | .[] | .categories[] | [.name, .budgeted, .activity, .balance] | @csv'
