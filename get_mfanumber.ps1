## Get all users MFA Phone number and stores them in a CSV file
Connect-MsolService
$users = Get-MsolUser -All | where {$_.isLicensed -eq $true}
$upn = $users.userprincipalname
$csv = "C:\mfa.csv"

try {
    New-Item $csv -ItemType File -Value ("upn,MFA_Num" + [Environment]::NewLine)
}
catch {
    Add-Content $csv ("upn,MFA_Num")
}

foreach ($user in $upn) {

    $userdetails = Get-MsolUser -userprincipalname $user
    $userMFANumber = $userdetails.StrongAuthenticationUserDetails.PhoneNumber
    Add-Content $csv ($user + "," + $userMFANumber)
}