# get cost for all customers last month

# notice our URIs and how we can use the data from previous endpoints as our URI. Classic Azure
$query = @"
{
    "type": "Usage",
    "timeframe": "LastMonth",
    "dataset": {
      "granularity": "None",
      "aggregation": {
        "totalCost": {
          "name": "PreTaxCost",
          "function": "Sum"
        }
      },
      "grouping": [
        {
          "type": "Dimension",
          "name": "CustomerName"
        }
      ]
    }
  }
"@

$headers = @{"Authorization" = "Bearer xxx"}

# 1: get billing account
$billingAccounts = (invoke-restmethod -uri "https://management.azure.com/providers/Microsoft.Billing/billingAccounts?api-version=2019-10-01-preview" -headers $headers).value
$billingAccountId = $billingAccounts.id


# 2: get billing profiles
$billingProfile = (invoke-restmethod -uri "https://management.azure.com$billingAccountId/billingProfiles?api-version=2019-10-01-preview" -headers $headers).value
$billingProfileId = $billingProfile.id

# 3 post query
$customerCost = Invoke-RestMethod -Method POST -Uri "https://management.azure.com$billingProfileId/providers/Microsoft.CostManagement/query?api-version=2019-11-01" -Body $query -Headers $headers -ContentType "Application/Json"

$customerCost.properties.rows