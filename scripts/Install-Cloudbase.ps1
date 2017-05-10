param ( 
	[string]$remote_path
)


$LogsPath  = "C:\Windows\Temp"
$arg_list = "-q -n -l $LogsPath\CloudInstall.log"

try {

	# 1. Download and install Cloudbase-Init
    if (!(Get-Service cloudbase-init -ErrorAction Ignore))
	{
		#Downloading setup.exe and determine offline/online mode
		if(($remote_path.Length -ne 0) -And (Test-Path $remote_path)) 
		  { 
			$path = "$remote_path\Cloudbase"
			$mode = "offline"
		  }
		else
		  { 
			$path = "C:\Windows\Temp"
			$mode = "online"
			Write-Host "Downloading Cloudbase-Init setup.exe"
			wget "https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi" -outfile "$path\CloudbaseInitSetup_x64.msi"
		  }

		#Installing Cloudbase-Init  
		Write-Host "Installing Cloudbase-Init from $mode repo"
		Start-Process -PassThru -Wait -FilePath "$path\CloudbaseInitSetup_x64.msi" -ArgumentList $arg_list
	}
	
	# 2. Set startup type to manual and change back to automatic in postunattend.xml
	if ((Get-Service cloudbase-init).StartType -ne "Manual") {Set-Service cloudbase-init -startuptype "manual"}
	
	# 3. Replace config file
	Copy-Item  -Path "A:\Scripts\cloudbase-init.conf" -Destination "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf" -force
}
catch 
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Throw "Install-Cloudbase failed at $FailedItem. The error message was $ErrorMessage"
}  