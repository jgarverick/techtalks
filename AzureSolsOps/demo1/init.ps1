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
(Get-Content -Path ./demo1/clownfirst.params.json).Replace("#Password",$Password.PasswordValue) | Out-File ./demo1/clownfirst.params.json -Force
$creds = New-Object System.Management.Automation.PSCredential("CLOWNFIRST\ringmaster",(ConvertTo-SecureString $Password.PasswordValue -AsPlainText -Force))

# Start by provisioning the AD DC and forest
# This uses the Azure QuickStart template from GitHub
New-AzureRmResourceGroupDeployment `
-ResourceGroupName $ResourceGroup `
-TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/active-directory-new-domain/azuredeploy.json `
-TemplateParameterFile ./demo1/clownfirst.params.json `
-Mode Incremental -Force

# Set up the hybrid automation worker VM
az vm create -n vmHW01 -g $ResourceGroup `
--nsg-rule RDP --image "Win2016Datacenter" --authentication-type password --admin-user "ringmaster" --admin-password $Password.PasswordValue

# Set up the Automation and OMS integration
$ConfigScript = Get-Content -Path ./demo1/Configure-HybridWorker.ps1
az vm run-command invoke -g $ResourceGroup -n vmHW01 --command-id RunPowerShellScript --script "$($ConfigScript)" --parameters $ResourceGroup,$SubscriptionId

# Send in the clowns
$NewUserScript = Get-Content -Path ./demo1/Create-Users.ps1
az vm run-command invoke -g $ResourceGroup -n vmHW01 --command-id RunPowerShellScript --script "$($NewUserScript)"

# Set up the credential for the domain user in the automation account
New-AzureRmAutomationCredential -ResourceGroupName $ResourceGroup -AutomationAccountName "OPS-AUTOMATION" -Name Ringmaster `
-Description "The master super admin account for the domain" -Value $creds