#$env:PACKER_LOG=1
$env:image_version="Server_2016_DataCenter"

#1. Construct autounattend.xml, postunattend.xml, packer_template_base.json
chef-client --local-mode --runlist 'windows-imaging' -j windows_versions.json

#2. Build base image
Write-Host "Build base image"
packer build --force packer_templates\packer_template_base.json

# Build updated image
Write-Host "Build upd1 image"
packer build --force packer_templates\packer_template_updated.json

# Build final image
Write-Host "Build final image"
packer build --force packer_templates\packer_template_final.json

#5. Copy final image to output folder
#copy output\final\*.* ..\output\ 

#6. Convert extra image to qcow2 format
#gci ..\output\*.vmdk | ForEach-Object{Invoke-Command -ScriptBlock {C:\distr\qemu-img\qemu-img.exe convert "..\output\$($_.Name)" -O qcow2 "..\output\$($_.BaseName).qcow2" }}
