$computerName = Read-Host "Enter a computer name: "

$desc = Read-Host "Enter the description: "

$cred = Get-Credential

 

 

Set-ADComputer -Identity $computerName -Credential $cred -Description $desc

 

write-host "Description has been changed"
