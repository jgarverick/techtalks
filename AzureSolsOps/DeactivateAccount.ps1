param (
    [string]
    [parameter(Mandatory=$true)]
    $Identity
)

# Get the credential
$adminCredential = Get-AutomationPSCredential -Name 'Ringmaster'
# Take care of the account
Disable-ADAccount -Identity $Identity -Credential $adminCredential