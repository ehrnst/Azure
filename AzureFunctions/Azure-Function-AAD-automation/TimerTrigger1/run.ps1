# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}
import-module Az.Accounts
Connect-AzAccount -Identity

$auth = Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com/.default"

(invoke-restmethod -uri "https://graph.microsoft.com/v1.0/users" -Headers @{"Authorization" = "Bearer " + $auth.Token}).value

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
