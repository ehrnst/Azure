# get customer by billing profile - CSP

$headers = @{"Authorization" = "Bearer xxx"}

# 1: get billing account
$billingAccounts = (invoke-restmethod -uri "https://management.azure.com/providers/Microsoft.Billing/billingAccounts?api-version=2019-10-01-preview" -headers $headers).value
$billingAccountName = $billingAccounts.name


# 2: get billing profiles
$billingProfile = (invoke-restmethod -uri "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$billingAccountName/billingProfiles?api-version=2019-10-01-preview" -headers $headers).value
$billingProfileName = $billingProfile.name

# 3: get list of customers
$customers = (Invoke-RestMethod -Uri "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$billingAccountName/billingProfiles/$billingProfileName/customers?api-version=2019-10-01-preview" -Headers $headers).value
