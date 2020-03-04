# authenticate using oAuth.
# for EA and CSP authentication/authorization requires correct permissions through respective APIs/Portals
$headers = @{"Authorization" = "Bearer xxx"}

# 1: get billing account
$billingAccounts = (invoke-restmethod -uri "https://management.azure.com/providers/Microsoft.Billing/billingAccounts?api-version=2019-10-01-preview" -headers $headers).value
$billingAccountName = $billingAccounts.name


# 2: get billing profiles
$billingProfile = (invoke-restmethod -uri "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$billingAccountName/billingProfiles?api-version=2019-10-01-preview" -headers $headers).value
$billingProfileName = $billingProfile.name
