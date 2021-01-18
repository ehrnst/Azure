    # this script will add event grid subscription at your current subscription context

    # eventTypes will allow only Resource Write Success events to be sent
    # advanced filter 1 will only trigger for resource group writes. If you want to subscribe to all resource events this can be changed
    # advanced filter 2 will ensure we're not triggering a new event for when our function writes the tag
    # -maxDeliveryAttempt and TTL is just to add more examples.

    $subscriptionId = (get-azcontext).Subscription.Id
    $functionResourceId  = Read-Host -Prompt "Complete function resource id"

    $eventTypes = "Microsoft.Resources.ResourceWriteSuccess"
    $filter1 = @{operator="StringBeginsWith"; key="Data.operationName"; Values=@("Microsoft.Resources/subscriptions/resourceGroups/write")}
    $filter2 = @{operator="StringNotIn"; key="Data.resourceType"; Values=@("Microsoft.Resources/tags")}
    $advancedFilters = @($filter1, $filter2)

    New-AzEventGridSubscription -ResourceId "/subscriptions/$subscriptionId" `
    -EventSubscriptionName "subscription-automation" -IncludedEventType $eventTypes -AdvancedFilter $advancedFilters `
    -EndpointType 'azurefunction' -Endpoint $functionResourceId -MaxDeliveryAttempt 10 -EventTtl 60