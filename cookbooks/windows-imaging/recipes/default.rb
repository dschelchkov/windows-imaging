#
# Cookbook:: windows-imaging
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

version_node = node["versions"]["#{ENV['image_version']}"]
general_node = node["general"]
working_dir = general_node["working_dir"]

directory "#{working_dir}/answer_files" do
end

template "#{working_dir}/answer_files/autounattend.xml" do
  source 'autounattend.xml.erb'
  variables( 
    :image => version_node["image_name"],
	:fullname => general_node["fullname"],
	:organization => general_node["organization"],
	:network_location => general_node["network_location"],
	:protect_pc => general_node["protect_pc"],
	:timezone => general_node["timezone"],
	:virtio_dir => version_node["virtio_dir"]
	)
end

template "#{working_dir}/answer_files/postunattend.xml" do
  source 'postunattend.xml.erb'
  variables( 
	:fullname => general_node["fullname"],
	:organization => general_node["organization"],
    :network_location => general_node["network_location"],
	:protect_pc => general_node["protect_pc"],
	:timezone => general_node["timezone"]
	)
end

directory "#{working_dir}/packer_templates" do
end

template "#{working_dir}/packer_templates/packer_template_base.json" do
  source 'packer_template_base.json.erb'
  variables( 
    :headless => general_node["headless"],
	:winrm_port => general_node["winrm_port"],
	:short_name => version_node["short_name"],
	
	:iso_checksum => version_node["iso_checksum"],
	:iso_url => version_node["image_iso"],
	:virtio_iso => general_node["virtio_iso"],
  )
end

["upd1", "upd2", "final"].each do |a|
  template "#{working_dir}/packer_templates/packer_template_#{a}.json" do
    source "packer_template_#{a}.json.erb"
    variables( 
      :headless => general_node["headless"],
	  :winrm_port => general_node["winrm_port"],
	  :short_name => version_node["short_name"]
    )
  end
end