param (
    [string]
    [parameter(Position=0)]
    $Editor="code"
)

switch($Editor){
	"vs" {$Editor="visualstudio2017enterprise"}
	"code" {$Editor = "vscode"}
}
cinst -y $Editor

if ($Editor -eq "vscode"){
	Get-Content -Path $PWD\ide\extensions.vscode.txt | foreach {
		code --install-extension $_
	}
}