$ProgressPreference='SilentlyContinue'
Import-Module A:\Scripts\PSWindowsUpdate\1.5.2.2\PSWindowsUpdate.psd1
Start-Sleep 30
Get-WUInstall -WindowsUpdate -AcceptAll -UpdateType Software -IgnoreReboot -Category "Critical Updates"
