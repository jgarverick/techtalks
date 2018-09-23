<#
PowerShell bootstrap script.
#>
param (
    [string]
    $Editor="code",
    [string]
    $ScriptLanguage="ps"
)

./env/init.ps1
./util/packages.ps1
./ide/install.ps1 $Editor
./custom/custom.ps1