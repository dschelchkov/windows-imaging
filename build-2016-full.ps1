$env:PACKER_LOG=1
$env:PWD=pwd
$env:image_version="Server_2016_DataCenter"

#1. Construct autounattend.xml, postunattend.xml, packer_template_base.json
chef-client --local-mode --runlist 'windows-imaging' -j windows_versions.json

#2. Build base image
packer build -force -only virtualbox-iso `
-var 'headless=true' `
packer_templates\packer_template_base.json

#3. Copy base image to output folder
copy output-virtualbox-iso\*.* ..\output\ 

#4. Add extras
packer build -force -only virtualbox-iso `
-var 'headless=true' `
packer_templates\packer_template_extra.json

#5. Copy extra image to output folder
copy output-virtualbox-iso\*.* ..\output\ 

#6. Convert extra image to qcow2 format
gci ..\output\*.vmdk | ForEach-Object{Invoke-Command -ScriptBlock {C:\distr\qemu-img\qemu-img.exe convert "..\output\$($_.Name)" -O qcow2 "..\output\$($_.BaseName).qcow2" }}
