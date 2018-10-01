function Add-Clown {
param (
    [string]
    $UserAlias,
    [string]
    $FirstName,
    [string]
    $LastName
)

$Email = "$($UserAlias)@clownfirst.com"

New-ADUser -Name "$($FirstName) $($LastName)" `
-EmailAddress $Email `
-SamAccountName $UserAlias `
-UserPrincipalName $Email -GivenName $FirstName -Surname $LastName
}

Add-Clown -UserAlias "bozo" -FirstName "Bob" -LastName "Bell"
Add-Clown -UserAlias "shakes" -FirstName "Bobcat" -LastName "Goldwaith"
Add-Clown -UserAlias "pennywise" -FirstName "William" -LastName "Skarsgard"
Add-Clown -UserAlias "krusty" -FirstName "Herschel" -LastName "Krustovsky"
Add-Clown -UserAlias "ringmaster" -FirstName "Administrative" -LastName "Account"
