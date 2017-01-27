. A:\Scripts\Set-ClientWSUSSetting.ps1 
Set-ClientWSUSSetting -UseWSUSServer Disable -AllowAutomaticUpdates Disable -AutoInstallMinorUpdates Disable

Restart-Service wuauserv
Start-Sleep 15
