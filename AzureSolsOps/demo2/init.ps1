param (
	[string]
	[parameter(Mandatory=$true)]
	$ResourceGroup,
	[string]
	[parameter(Mandatory=$true)]
	$SubscriptionId
)
# Create the API endpoint connection
# Powershell courtesy of https://social.msdn.microsoft.com/Forums/en-US/b24e44da-d400-43dd-a947-1c3d5a316aca/create-api-connection-for-logic-app-from-powershell?forum=azurelogicapps
$properties= @{"displayName" = "Dev"; "api" = @{"id" = "/subscriptions/$($SubscriptionId)/providers/Microsoft.Web/locations/eastus/managedApis/service-now"} 
New-AzureRmResource -Location "East US" -ResourceType microsoft.web/connections -ResourceName "service-now" -ResourceGroupName $ResourceGroup -Properties $properties

# Create the Logic App
./Set-LogicApp.ps1 -ResourceGroup $ResourceGroup