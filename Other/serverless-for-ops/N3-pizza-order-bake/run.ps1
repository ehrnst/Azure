param($eventGridEvent, $TriggerMetadata)


Start-Sleep -Seconds 10

$eventID = (new-guid)

#Date format should be SortableDateTimePattern (ISO 8601)
$eventDate = Get-Date -Format s
$orderid = $eventGridEvent.data.order.orderId

#create the event
$htbody = @{
    id          = $eventID
    eventType   = "PizzaOrder"
    subject     = "$orderid/cooked"
    eventTime   = $eventDate   
    data        = @{
        "correlationId" = $eventGridEvent.data.correlationId
        "customer"      = @{
            "firsname" = $eventGridEvent.data.customer.firsname
            "lastName" = $eventGridEvent.data.customer.lastName
        }
        "order"         = @{
            "pizza"    = $eventGridEvent.data.order.pizza
            "quantity" = $eventGridEvent.data.order.quantity
            "orderId"  = $orderid
        }
    }
    dataVersion = "1.0"
}

$body = "[" + (ConvertTo-Json $htbody -Depth 4) + "]"

Invoke-RestMethod -Uri $ENV:EVENT_GRID_TOPIC_URI -Method POST -Body $body -Headers @{"aeg-sas-key" = $ENV:AEG_SAS_KEY }

# Make sure to pass hashtables to Out-String so they're logged correctly
$eventGridEvent.data | Out-String | Write-Host
