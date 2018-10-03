param (
	[string]
	[parameter(Mandatory=$true,Position=0)]
	$ResourceGroup,
	[string]
	[parameter(Mandatory=$true,Position=1)]
	$SubscriptionId
)

Install-Script -Name New-OnPremiseHybridWorker -Verbose
Add-WindowsFeature RSAT-AD-Powershell -Verbose
New-OnPremiseHybridWorker.ps1 -AAResourceGroupName $ResourceGroup -OMSResourceGroupName $ResourceGroup -SubscriptionID $SubscriptionId -WorkspaceName OPS-ANALYTICS -AutomationAccountName OPS-AUTOMATION -HybridGroupName CLOWNFIRST -Verbose