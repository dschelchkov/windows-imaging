param ( 
	[string]$remote_path,
	[string]$packages = "openssh,rsync,procps,cygrunsrv,lynx,wget,curl,bzip,tar,make,gcc-c,gcc-g++,libxml2"	
)

try {

	# 1. Download and install Cygwin
    if (!(Test-Path "C:\cygwin64\bin\bash.exe"))
	{
		#Downloading setup.exe and determine offline/online mode
		if(($remote_path.Length -ne 0) -And (Test-Path $remote_path)) 
		  { 
			$path = "$remote_path\Cygwin"
			$arg_list = "-q -n -R C:\cygwin64 -P $packages -L -l $path\CygwinPackages"
			$mode = "offline"
		  }
		else
		  { 
			$path = "C:\Windows\Temp"
			$arg_list = "-q -n -R C:\cygwin64 -P $packages -s http://cygwin.mirror.constant.com/"
			$mode = "online"
			Write-Host "Downloading Cygwin setup.exe"
			wget "https://cygwin.com/setup-x86_64.exe" -outfile "$path\CygwinSetup-x86_64.exe"
		  }

		#Installing Cygwin  
		Write-Host "Installing Cygwin from $mode repo"
		Start-Process -PassThru -Wait -FilePath "$path\CygwinSetup-x86_64.exe" -ArgumentList $arg_list
	}


	# 2. Set up sshd service
	if (!(Get-Service sshd -ErrorAction Ignore))
	{
		#generate a random password
		[Reflection.Assembly]::LoadWithPartialName("System.Web")
		$random_password = "Ez1!_"+[System.Web.Security.Membership]::GeneratePassword(20,0) 
			
		Invoke-Command -ScriptBlock {C:\cygwin64\bin\bash.exe --login -i ssh-host-config -y -c "tty ntsec" -N "sshd" -u "cyg_server" -w $random_password} 
		# Create allow firewall rule for SSH traffic
		Write-Host "Creating SSH-Inbound firewall rule"
		Invoke-Command -ScriptBlock {netsh advfirewall firewall add rule name="SSH-Inbound" dir=in action=allow enable=yes localport=22 protocol=tcp}
	}
        
    # 3. Start sshd service
    if ((Get-Service sshd).Status -ne "Running") {Start-Service sshd}
	
}
catch 
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Throw "Cygwin-Install failed at $FailedItem. The error message was $ErrorMessage"
}  
