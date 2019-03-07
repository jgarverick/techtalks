param (
    [string]
    [parameter(Mandatory=$true)]
    $ResourceGroup
)

Import-AzureRmContext -Path $env:HOME/azdemo.json

New-AzureRmLogicApp -ResourceGroupName $ResourceGroup -Name AZ-LA-ITSM-INTEGRATION -Location EastUS `
-DefinitionFilePath ./la-itsm-integration.json

