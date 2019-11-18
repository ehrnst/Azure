# script to send event grid events
$eventGridTopicURI = ""
$aegSASkey = ""

$eventID = (new-guid)
$correlationId = (new-guid)


#Date format should be SortableDateTimePattern (ISO 8601)
$eventDate = Get-Date -Format s

#region newOrders
$htbody = @{
    id          = $eventID
    eventType   = "PizzaOrder"
    subject     = "Order/New"
    eventTime   = $eventDate   
    data        = @{
        "correlationId" = $correlationId
        "customer"      = @{
            "firsname" = "Donald"
            "lastName" = "Trump"
        }
        "order"         = @{
            "pizza"      = "The wall"
            "quantity"     = 1
        }
    }
    dataVersion = "1.0"
}

$body = "[" + (ConvertTo-Json $htbody -Depth 4) + "]"

Invoke-RestMethod -Uri $eventGridTopicURI -Method POST -Body $body -Headers @{"aeg-sas-key" = $aegSASkey }