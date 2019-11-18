param($eventGridEvent, $TriggerMetadata)


$eventID = (new-guid)
$correlationId = (new-guid)

#Date format should be SortableDateTimePattern (ISO 8601)
$eventDate = Get-Date -Format s
$orderId = Get-Random -Maximum 9999 # create an order id to use later

#region newOrders
$htbody = @{
    id          = $eventID
    eventType   = "PizzaOrder"
    subject     = "$orderid/Received"
    eventTime   = $eventDate   
    data        = @{
        "correlationId" = $correlationId
        "customer"      = @{
            "firsname" = $eventGridEvent.data.customer.firsname
            "lastName" = $eventGridEvent.data.customer.lastName
        }
        "order"         = @{
            "pizza"  = $eventGridEvent.data.order.pizza
            "quantity" = $eventGridEvent.data.order.quantity
            "orderId" = $orderId
        }
    }
    dataVersion = "1.0"
}

$body = "[" + (ConvertTo-Json $htbody -Depth 4) + "]"

Invoke-RestMethod -Uri $ENV:EVENT_GRID_TOPIC_URI -Method POST -Body $body -Headers @{"aeg-sas-key" = $ENV:AEG_SAS_KEY }

# Make sure to pass hashtables to Out-String so they're logged correctly
$eventGridEvent.data | Out-String | Write-Host
