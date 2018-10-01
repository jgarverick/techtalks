param (
    [string]
    [parameter(Mandatory=$true)]
    $ResourceGroup
)

Import-AzureRmContext -Path $env:HOME/azdemo.json

New-AzureRmOperationalInsightsWorkspace -ResourceGroupName $ResourceGroup -Name OPS-ANALYTICS `
-Location EastUS