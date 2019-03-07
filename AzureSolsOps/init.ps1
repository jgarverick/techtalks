param (
    [string]
    [parameter(Mandatory=$true)]
    $SubscriptionName,
	[string]
    [parameter(Mandatory=$true)]
    $ResourceGroup
)

if(!(Test-Path $env:USERPROFILE\azdemo.json)) {
	Connect-AzureRmAccount
	Select-AzureRmSubscription -SubscriptionName $SubscriptionName
	Save-AzureRmContext -Path $env:USERPROFILE\azdemo.json
}

Select-AzureRmSubscription -SubscriptionName $SubscriptionName

az login
# set the account you want to use
az account set -s $SubscriptionName

# set up the extensions you need/want
az extension add --name eventgrid
az extension add --name log-analytics

az group create --name $ResourceGroup --location EastUS

# set up the Automation Account
./Set-Automation.ps1 -ResourceGroup $ResourceGroup
# set up Log Analytics
./Set-LogAnalytics.ps1 -ResourceGroup $ResourceGroup

# To export the resource group as an ARM template, uncomment the following
# az group export -g $ResourceGroup -o JSON > template.json

$SubscriptionId = (az account show --query "id")

./demo1/init.ps1 -SubscriptionId $SubscriptionId -ResourceGroup $ResourceGroup