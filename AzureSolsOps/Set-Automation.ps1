param (
    [string]
    [parameter(Mandatory=$true)]
    $ResourceGroup
)

Import-AzureRmContext -Path $env:HOME/azdemo.json

New-AzureRmAutomationAccount -ResourceGroupName $ResourceGroup -Name OPS-AUTOMATION -Location EastUS2
# Import the DNS module for DSC
Import-AzureRmAutomationModule -Name xDnsServer -AutomationAccountName OPS-AUTOMATION -ResourceGroupName $ResourceGroup `
-ContentLinkUri https://www.powershellgallery.com/packages/xDnsServer/1.11.0.0

