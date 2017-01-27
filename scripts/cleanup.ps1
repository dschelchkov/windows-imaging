Write-Host "Cleaning SxS..."
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

Write-Host "Uninstall Chef..."
if(Test-Path "c:\windows\temp\chef.msi") {
  Start-Process MSIEXEC.exe '/uninstall c:\windows\temp\chef.msi /quiet' -Wait
}

@(
    #"$env:localappdata\Nuget",
    #"$env:localappdata\temp\*",
    #"$env:windir\logs",
    #"$env:windir\panther",
    "$env:windir\temp\*"
    #"$env:windir\winsxs\manifestcache"
) | % {
        if(Test-Path $_) {
            Write-Host "Removing $_"
            try {
              Takeown /d Y /R /f $_
              Icacls $_ /GRANT:r administrators:F /T /c /q  2>&1 | Out-Null
              Remove-Item $_ -Recurse -Force | Out-Null 
            } catch { $global:error.RemoveAt(0) }
        }
    }
	

Write-Host "Optimizing Drive"
Optimize-Volume -DriveLetter C

Write-Host "Wiping empty space on disk..."
$FilePath="c:\zero.tmp"
$Volume = Get-WmiObject win32_logicaldisk -filter "DeviceID='C:'"
$ArraySize= 64kb
$SpaceToLeave= $Volume.Size * 0.05
$FileSize= $Volume.FreeSpace - $SpacetoLeave
$ZeroArray= new-object byte[]($ArraySize)
 
$Stream= [io.File]::OpenWrite($FilePath)
try {
   $CurFileSize = 0
    while($CurFileSize -lt $FileSize) {
        $Stream.Write($ZeroArray,0, $ZeroArray.Length)
        $CurFileSize +=$ZeroArray.Length
    }
}
finally {
    if($Stream) {
        $Stream.Close()
    }
}
 
Del $FilePath
