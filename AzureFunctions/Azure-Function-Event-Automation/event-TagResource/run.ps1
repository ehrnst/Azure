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
# set date/time for tagging. i chose to run with day to simplify.
# get user information to use in tag. If no user is present (ie: SPN, get the object identifier)

$eventData = $eventGridEvent.data
$resourceId = $eventData.resourceUri
$date = [DateTime]::UtcNow.ToString('yyyy-MM-dd')
$principal = $eventData.claims.name

if( $null -eq $principal ) {
    $principal = $eventData.claims.'http://schemas.microsoft.com/identity/claims/objectidentifier'
}

# updating the resource tags
# we merge with existing tags
try {
    Write-Information "updating tags on $resourceId"
    $tagsToAdd = @{
        "last-review" = $date
        "last-updated-by" = $principal
    }

    Update-AzTag -Tag $tagsToAdd -ResourceId $resourceId -Operation Merge -ErrorAction Stop
}

catch {
    Write-Error -Message $_.Exception
}