call winrm set winrm/config/service/auth @{Basic="false"}
call winrm set winrm/config/service @{AllowUnencrypted="false"}
rem netsh advfirewall firewall set rule name="WinRM-HTTP" new action=block

copy a:\postunattend.xml C:\Windows\Setup\postunattend.xml
mkdir C:\Windows\Setup\Scripts
copy a:\Scripts\SetupComplete.cmd C:\Windows\Setup\Scripts\SetupComplete.cmd
C:/windows/system32/sysprep/sysprep.exe /generalize /oobe /unattend:C:\Windows\Setup\postunattend.xml /quiet /shutdown 
