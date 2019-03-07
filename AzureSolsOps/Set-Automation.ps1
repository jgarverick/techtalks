param (
    [string]
    [parameter(Mandatory=$true)]
    $ResourceGroup
)

Import-AzureRmContext -Path $env:USERPROFILE\azdemo.json

New-AzureRmAutomationAccount -ResourceGroupName $ResourceGroup -Name OPS-AUTOMATION -Location EastUS2
# Import the DNS module for DSC
Import-AzureRmAutomationModule -Name xDnsServer -AutomationAccountName OPS-AUTOMATION -ResourceGroupName $ResourceGroup `
-ContentLinkUri https://www.powershellgallery.com/packages/xDnsServer/1.11.0.0
# Create runbooks
Import-AzureRMAutomationRunbook -AutomationAccountName OPS-AUTOMATION -Name DeactivateAccount -Path ./DeactivateAccount.ps1 -ResourceGroupName $ResourceGroup -Type PowerShell
Import-AzureRMAutomationRunbook -AutomationAccountName OPS-AUTOMATION -Name ConfigureHybridWorker -Path ./demo1/Configure-HybridWorker.ps1 -ResourceGroupName $ResourceGroup -Type PowerShell
Import-AzureRMAutomationRunbook -AutomationAccountName OPS-AUTOMATION -Name CreateUsers -Path ./demo1/Create-Users.ps1 -ResourceGroupName $ResourceGroup -Type PowerShell

