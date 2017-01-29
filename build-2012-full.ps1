#$env:PACKER_LOG=1
$env:image_version="Server_2012_DataCenter"

#1. Construct autounattend.xml, postunattend.xml, packer_template_base.json
chef-client --local-mode --runlist 'windows-imaging' -j windows_versions.json

#2. Build full image
Write-Host "Build base image"
packer build --force packer_templates\packer_template_full.json


#5. Copy final image to output folder
#copy output\final\*.* ..\output\ 

#6. Convert extra image to qcow2 format
#gci ..\output\*.vmdk | ForEach-Object{Invoke-Command -ScriptBlock {C:\distr\qemu-img\qemu-img.exe convert "..\output\$($_.Name)" -O qcow2 "..\output\$($_.BaseName).qcow2" }}
