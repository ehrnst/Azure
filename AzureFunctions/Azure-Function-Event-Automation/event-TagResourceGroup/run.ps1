param($eventGridEvent, $TriggerMetadata)

# DEMO PURPOSES - alot of commenting
# Function will tag resources when they are created (triggered from event grid/subscription)


# connect to azure using managed service identity (MSI)
# You will have to enable MSI on you app and allow it to modify resources - CONTRIBUTOR
try {
    Write-Information "connecting to Azure resource manger"
    Connect-AzAccount -Identity
}

catch {
    Write-Error -Message $_.Exception
}

# Grab domain specific data from the incoming event.
# set date/time for tagging. i chose to run with UTC sortable format for simplicity
# get user information to use in tag.

$eventData = $eventGridEvent.data
$resourceGroupId = $eventData.resourceUri
$date = [DateTime]::UtcNow.ToString('u')
$user = $eventData.claims.name

# get the resource group and its current tags
# build a hastable of existing and new tags
try {
    Write-Information "getting resource group"
    $RG = Get-AzResourceGroup -ResourceGroupId $resourceGroupId
    $tags = $rg.Tags
    $tags += @{
        "createdDateUTC" = $date;
        "createdBy" = $user
    }

    Write-Information "updating tags on resource group $rg.resourceGroupName"
    Set-AzResourceGroup -Name $rg.ResourceGroupName -Tag $tags
}

catch {
    Write-Error -Message $_.Exception
}