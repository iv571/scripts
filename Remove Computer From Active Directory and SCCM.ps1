$assetTag = Read-Host "Enter the Asset Tag: "

 

#Authenticate

$credential = Get-Credential -Message "User credentials are required to perform this action" -UserName $env:UserName

 

#remove from AD

Get-ADComputer -Identity $assetTag -Credential $credential | Remove-ADObject -Recursive

 

 

 

#remove from SCCM

Set-Location 'C:\Program Files (x86)\ConfigMgr Console\bin'

Import-Module ".\ConfigurationManager.psd1"

 

New-PSDrive -Name "SCCM" -PSProvider "CMSite" -Root "cgyut249.ad.corp.local" -Description "Primary site"

Set-Location "SCCM:"

Remove-CMDevice -Name $assetTag

 

Write-Host "Computer removed"
