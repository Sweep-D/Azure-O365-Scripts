## Get all users MFA Phone number and stores them in a CSV file
Connect-MsolService
$users = Get-MsolUser -All | where {$_.isLicensed -eq $true}
$csv = "C:\tmp\mfa.csv"

try {
    New-Item $csv -ItemType File -Value ("Display,upn,Mobile_Number" + [Environment]::NewLine)
}
catch {
    Add-Content $csv ("Display Name,upn,Mobile_Number")
}

foreach ($user in $users) {
    $userDisplayName = $user.DisplayName
    $userMFANumber = $user.StrongAuthenticationUserDetails.PhoneNumber
    Add-Content $csv ($userDisplayName + "," + $user.userprincipalname + "," + $userMFANumber)
}