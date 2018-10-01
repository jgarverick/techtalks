param (
	[string]
	[parameter(Mandatory=$true)]
	$ResourceGroup,
	[string]
	[parameter(Mandatory=$true)]
	$SubscriptionId
)

Install-Module RandomPasswordGenerator
# Create the password used for the admin account
$Password = Get-RandomPassword
(Get-Content -Path clownfirst.params.json).Replace("#Password",$Password.PasswordValue) | Out-File ./clownfirst.params.json
# Start by provisioning the AD DC and forest
# This uses the Azure QuickStart template from GitHub
New-AzureRmResourceGroupDeployment -Name "clownfirst" `
-ResourceGroupName $ResourceGroup `
-TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/active-directory-new-domain `
-TemplateParameterFile clownfirst.params.json `
-Mode Complete
# Set up the hybrid automation worker VM
New-AzureRmVM -Name vmHW01 -ResourceGroupName $ResourceGroup `
-VirtualNetworkName adVNET -SubnetName "default"
# Set up the Automation and OMS integration
az vm run-command invoke -g $ResourceGroup -n vmHW01 --command-id RunPowershellScript --script "Install-Script -Name New-OnPremiseHybridWorker;Add-WindowsFeature RSAT-AD-Powershell;New-OnPremiseHybridWorker.ps1 -AAResourceGroupName $($ResourceGroup) -OMSResourceGroupName $($ResourceGroup) -SubscriptionID $($SubscriptionId) -WorkspaceName OPS-ANALYTICS -AutomationAccountName OPS-AUTOMATION -HybridGroupName CLOWNFIRST"
# Send in the clowns
$NewUserScript = Get-Content -Path ./Create-Users.ps1
az vm run-command invoke -g $ResourceGroup -n vmHW01 --command-id RunPowershellScript --script "$($NewUserScript)"
# Set up the credential for the domain user in the automation account
$creds = New-Object System.Management.Automation.PSCredential("CLOWNFIRST\ringmaster",(ConvertTo-SecureString $Password -AsPlainText -Force))
New-AzureRmAutomationCredential -ResourceGroupName $ResourceGroup -AutomationAccountName "OPS-AUTOMATION" -Name Ringmaster `
-Description "The master super admin account for the domain" -Value $creds