# get customer resource cost last month
# notice our URIs and how we can use the data from previous endpoints as our URI. Classic Azure
$query = @"
{
    "type": "Usage",
    "timeframe": "TheLastMonth",
    "dataset": {
      "granularity": "Daily",
      "aggregation": {
        "totalCost": {
          "name": "PreTaxCost",
          "function": "Sum"
        }
      },
      "grouping": [
        {
          "type": "Dimension",
          "name": "ResourceId"
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

$customers = (Invoke-RestMethod -Uri "https://management.azure.com$billingProfileId/customers?api-version=2019-10-01-preview" -Headers $headers).value

# 3: grab a single customers id - notice the id is a classic Azure ID. Meaning we can use that in our URI
# post the query

$customerId = $customers[0].id
$resourceCost = Invoke-RestMethod -Method POST -Uri "https://management.azure.com$customerId/providers/Microsoft.CostManagement/query?api-version=2019-11-01" -Body $query -Headers $headers -ContentType "Application/Json"

$resourceCost.properties.rows