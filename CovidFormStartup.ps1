# Deploying a script to create a scheduled task to run at logon and then self delete. 
# For the stubborn computers that we can't reach conventionally...
$source="C:\Users"

$scriptblock = {
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "Start-Process 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe':<FORM URL>;Start-Sleep 1;(New-Object -ComObject wscript.shell).SendKeys('{F11}')"

$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday,Tuesday,Wednesday,Thursday,Friday -At 10:00am

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Covid_tracking" -Description "Asking users to say where they are logging in from each day" -settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd) -Force
}

Get-ChildItem $source | ForEach-Object { 
    echo $scriptblock | out-string -width 4096 | out-file C:\tmp\CreateSchedule.ps1
    New-Item -type File -Path C:\Users\$_\AppData\Roaming\Microsoft\Windows\'Start Menu'\Programs\Startup\ -Name startCFS.bat
    Set-content -Path C:\Users\$_\AppData\Roaming\Microsoft\Windows\'Start Menu'\Programs\Startup\startCFS.bat -Value '@echo off'
    Add-content -Path C:\Users\$_\AppData\Roaming\Microsoft\Windows\'Start Menu'\Programs\Startup\startCFS.bat -Value 'powershell.exe -executionpolicy bypass -file C:\tmp\CreateSchedule.ps1'
    Add-content -Path C:\Users\$_\AppData\Roaming\Microsoft\Windows\'Start Menu'\Programs\Startup\startCFS.bat -Value 'del C:\tmp\CreateSchedule.ps1'
    Add-content -Path C:\Users\$_\AppData\Roaming\Microsoft\Windows\'Start Menu'\Programs\Startup\startCFS.bat -value 'del startCFS.bat'
}
