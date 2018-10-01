param (
    [string]
    [parameter(Mandatory=$true)]
    $SubscriptionName
)

az login
# set the account you want to use
az account set -s $SubscriptionName

# set up the extensions you need/want
az extension add --name eventgrid
az extension add --name log-analytics

az group create --name RG-AZ-AUTOMATION-OPS --location EastUS

# set up the Automation Account
./Set-Automation.ps1 -ResourceGroup RG-AZ-AUTOMATION-OPS
# set up Log Analytics
./Set-LogAnalytics.ps1 -ResourceGroup RG-AZ-AUTOMATION-OPS

# To export the resource group as an ARM template, uncomment the following
# az group export -g RG-AZ-AUTOMATION-OPS -o JSON > template.json

$SubscriptionId = (az account show --query "id")

./demo1/init.ps1 -SubscriptionId $SubscriptionId -ResourceGroup "RG-AZ-AUTOMATION-OPS"