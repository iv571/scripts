$user = read-host "Enter a username: "

$newPassword = read-host "Enter a new password: " -AsSecureString

$credential = Get-Credential

 

Set-ADAccountPassword -Identity $user -NewPassword $newPassword -Reset -Credential $credential

Set-ADUser -Identity $user -ChangePasswordAtLogon $true -Credential $credential