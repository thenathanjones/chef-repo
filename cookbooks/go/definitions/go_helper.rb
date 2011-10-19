define :template_go_config, :action => :install do
  
  template "/tmp/license.xml" do
    source "license.xml.erb"
  end
  
  template "/tmp/pipelines.xml" do
    source "pipelines.xml.erb"
  end
  
  ruby_block "update Go config" do
    block do
      GoHelper.template_config
    end
  end
end

class GoHelper
  
  def self.template_config
    require 'rubygems'
    require 'nokogiri'
    
    filename = "/etc/go/cruise-config.xml"
    input = Nokogiri::XML(File.new(filename))
    
    input.root['schemaVersion'] = '24'

    input.root.xpath("//license").remove
    server_section = input.root.xpath("//server")
    new_license_section = Nokogiri::XML(File.new("/tmp/license.xml"))
    input.root.xpath("//server").first.add_child new_license_section.root

    input.root.xpath("//pipelines").remove
    pipelines_section = Nokogiri::XML(File.new("/tmp/pipelines.xml"))
    input.root.add_child pipelines_section.root

    File.open(filename, 'w') {|f| f.write(input.to_xml) }
  end
end