# add new subscription using Azure Costmanagement api. Example will only work for Azure Plan
# official example: https://docs.microsoft.com/bs-latn-ba/azure/azure-resource-manager/management/programmatically-create-subscription

# set a few parameters and a header.
# use 'standard' azure authentication to aquire a bearer token.
# if used with CSP, delegated permissions and secure app model is required
$headers = @{
    "Authorization" = "Bearer eyJ0eXAiOiJKV1Q"
}

$skuID = "0001" #apparently Azure plan sku ID
$subscriptionName = "rest-test"

# 1: get billing account and it's id. I only have access to one in this example
$billingAccounts = Invoke-RestMethod -Method GET -Uri "https://management.azure.com/providers/Microsoft.Billing/billingAccounts?api-version=2019-10-01-preview" -Headers $headers
$billingAccountName = $billingAccounts.value.name

# 2: getting customers under billing account
$customers = Invoke-RestMethod -Method get -uri "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$billingAccountName/customers?api-version=2019-10-01-preview" -Headers $headers

# 3: Using the customerId. Place a subscription order.
$customerId = "/providers/Microsoft.Billing/billingAccounts/<id>/customers/<id>"

$subscription = @"
{
    "displayName": "$subscriptionName",
    "skuId": "$skuId"
}
"@
Invoke-RestMethod -Method POST -Uri "https://management.azure.com$customerId/providers/Microsoft.Subscription/createSubscription?api-version=2018-11-01-preview" -Headers $headers -Body $subscription

