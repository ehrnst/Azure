using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace Adatum.demo
{
    public static class RetriveAndStoreData_timer
    {
        [FunctionName("RetriveAndStoreData_timer")]
        public static void Run([TimerTrigger("0 */10 * * * *")]TimerInfo myTimer,
                [CosmosDB(
                databaseName: "365Incidents",
                collectionName: "customerIncidentReport",
                ConnectionStringSetting = "CosmosDBConnectionString",
                CreateIfNotExists = true)]string data,
                 ILogger log)
        {
            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");
        }
    }
}
