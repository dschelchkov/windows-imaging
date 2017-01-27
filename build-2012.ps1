$env:PACKER_LOG=1
$env:PWD=pwd
$env:image_version="Server_2012_R2_DataCenter"


#1. Construct autounattend.xml, postunattend.xml, packer_template_base.json
chef-client --local-mode --runlist 'windows-imaging' -j windows_versions.json

#2. Build base image
packer build -force -only virtualbox-iso `
-var 'headless=true' `
-var 'stagefiles=C:\src\share\imaging\mypacker\stage_files' `
packer_templates\packer_template_base.json

#3. Add extras
#packer build -force -only virtualbox-iso .\vbox-2016-3.json