# this script will assign permissions for the managed identity to access microsoft graph
import-module AzureAd -UseWindowsPowerShell
Connect-AzureAD
# Replace with your managed identity
$managedIdentity = "273c805b-8501-463f-a7b3-6c4e82c25ff0"

# msft graph app
$appId = "00000003-0000-0000-c000-000000000000"

# Replace with the API permissions required by your app
$permission = "User.Read.All"

$app = Get-AzureADServicePrincipal -Filter "AppId eq '$appId'"


$role = $app.AppRoles | Where-Object Value -Like $permission
New-AzureADServiceAppRoleAssignment -Id $role.Id -ObjectId $managedIdentity -PrincipalId $managedIdentity -ResourceId $app.ObjectId