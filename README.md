# windows-imaging
Automation of building windows images

Requires:
  packer - https://www.packer.io/downloads.html
  ChefDK - https://downloads.chef.io/chefdk
  VirtualBox - https://www.virtualbox.org/wiki/Downloads
  
Optional: qemu-img

Before running please set up attributes in windows_versions.json general node.
Also update image_iso and iso_checksum attributes in versions node.
Currently these 2 versions are supported - Windows Server 2012 R2 Datacenter and Windows Server 2016 Datacenter. 
You can add your own versions to windows_versions.json.

Then to run a build execute on of the .ps1 files in the root folder of the project. Or create your own shell file.
