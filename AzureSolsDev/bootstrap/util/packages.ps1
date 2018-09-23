<#
Package management setup
1. Install chocolatey, if windows
2. Install package(s), if windows

If not, run the shell script.
#>
if($env:OS -eq "Windows_NT") {
	  Set-ExecutionPolicy Bypass -Scope Process -Force
	  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 
	  # Get some basics
	  cinst	git nodejs googlechrome jmeter docker-for-windows azure-cli vsts-cli -y
	  npm install -g artillery yeoman 
	  

} else {
    .$PWD/util/pacmgr.sh
}
