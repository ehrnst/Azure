# set role assignment for the function app on subscription
# script requires owner permission on specified subscription and MSI enabled on the function app

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $subscriptionId,

    [Parameter()]
    [string]
    $managedIdentityRole = "Tag Contributor"
)
$functionResourceId = "{set to your function app resource id"

$managedIdentity = (Get-AzResource -Id $functionResourceId).Identity.PrincipalId

try {
    $roledefinitionId = (Get-AzRoleDefinition -Name $managedIdentityRole).Id
    New-AzRoleAssignment -ObjectId $managedIdentity -RoleDefinitionId $roledefinitionId -Scope "/subscriptions/$subscriptionId"
}

catch {
    Write-Error $_.Exception.Message
    break
}