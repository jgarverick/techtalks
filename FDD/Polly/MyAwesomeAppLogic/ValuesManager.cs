using System;
using System.Configuration;
using System.Diagnostics;
using System.Net.Http;
using Polly;

namespace MyAwesomeAppLogic
{
    public class ValuesManager
    {
        public static string TestRetry(int retries){
            string output = "";

            var policy = Policy.Handle<Exception>()
                .WaitAndRetry(
                retryCount: retries, 
                sleepDurationProvider: retryAttempt =>
                    TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)),
                onRetry:(exception, calculatedWaitDuration) =>{
                    output += "Error!  HTTP code: " + exception.Message + "\r\n";
                });

            try
            {
                var result = policy.Execute<string>(() =>
                {


                    using (var request = new HttpRequestMessage(HttpMethod.Get, "https://kjon4pfinq34qrv"))
                    {
                        HttpClient client = new HttpClient();
                        var response = client.SendAsync(request).Result;
                        if (response.StatusCode == System.Net.HttpStatusCode.OK)
                        {
                            output = "Website was successfully hit.";
                        }
                        else
                        {
                            throw new HttpRequestException(response.StatusCode.ToString());
                        }
                    }

                    return output;

                });
            } catch (Exception e)
            {
                // Don't just catch and ignore; log or do something
                Microsoft.ApplicationInsights.TelemetryClient telemetryClient = new Microsoft.ApplicationInsights.TelemetryClient();
                telemetryClient.TrackException(e);
                output += "Call eventually failed after " + retries.ToString() + " retries.";
            }
            return output;
        }

        public static void TestTimeout(int timeout, string stuffToTest) {
            var policy = Policy.Timeout(timeout);
            policy.ExecuteAndCapture<string>(() =>
            {
                return "You appear to be having a bad time.";
            });
        }

        public static string[] TestBulkhead(int maxParallel, int queued){
            var policy = Policy.Bulkhead(maxParallel, queued, (context) =>
            {
                Debug.Write("Slooooooow doooooooown");
            });
            return policy.Execute(() =>
            {
                return new string[] { "value1", "value2" };
            });
        }

    }
}
