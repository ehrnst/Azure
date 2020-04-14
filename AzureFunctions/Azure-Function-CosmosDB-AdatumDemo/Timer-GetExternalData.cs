using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs.Extensions.Http;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace AdatumNO.Demo
{
    public static class Timer_GetExternalData
    {
        [FunctionName("Timer_GetExternalData")]
        public static void Run([TimerTrigger("0 */5 * * * *", RunOnStartup = true)]TimerInfo myTimer, 
        [CosmosDB(
                databaseName: "covid19",
                collectionName: "countryStats",
                ConnectionStringSetting = "COSMOSDB_CONNECTION_STRING",
                PartitionKey = "/country_code",
                CreateIfNotExists = true)]IAsyncCollector<dynamic> docOut,
        ILogger log)
        {
            log.LogInformation($"Getting daily covid-19 stats: {DateTime.Now}");
            HttpClient coronaClient = new HttpClient();
            var response = coronaClient.GetAsync("https://coronavirus-tracker-api.herokuapp.com/v2/locations?source=jhu");
            var data = Newtonsoft
            
        }
    }
}
