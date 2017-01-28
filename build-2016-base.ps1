$env:PACKER_LOG=1
$env:image_version="Server_2016_DataCenter"

#1. Construct autounattend.xml, postunattend.xml, packer_template_base.json
chef-client --local-mode --runlist 'windows-imaging' -j windows_versions.json

#2. Build base image
Write-Host "Build base image"
packer build --force packer_templates\packer_template_base.json

# Build upd1 image
Write-Host "Build upd1 image"
packer build packer_templates\packer_template_upd1.json

# Build upd2 image
Write-Host "Build upd2 image"
packer build packer_templates\packer_template_upd2.json

# Build final image
Write-Host "Build final image"
packer build packer_templates\packer_template_final.json

#3. Copy base image to output folder
#copy output-virtualbox-iso\*.* ..\output\ 
