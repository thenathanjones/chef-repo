define :template_go_config, :action => :install do
  
  required_nokogiri_packages = ["libxml2","libxml2-devel","libxslt","libxslt-devel"]
  required_nokogiri_packages.each do |package_name|
    package "#{package_name}"
  end
    
  gem_package "nokogiri"
  # this is required for Chef to include the new gem
  Gem.clear_paths
  
  template "/tmp/license.xml" do
    source "license.xml.erb"
  end
  
  template "/tmp/pipelines.xml" do
    source "pipelines.xml.erb"
  end
  
  ruby_block "update Go config" do
    block do
      GoHelper.template_config params[:config]
    end
  end
end

class GoHelper
  
  def self.template_config config
    require 'rubygems'
    require 'nokogiri'
    
    filename = "/etc/go/cruise-config.xml"
    input = Nokogiri::XML(File.new(filename))

    input.root['schemaVersion'] = '41'

    server_section = input.root.xpath("//server")
    if (!server_section.any?) 
      input.root.add_child("<server artifactsdir=\"artifacts\"></server>")
    end
      
    # Go Community doesn't require a license, so only template this if provided
    license_section = input.root.xpath("//license")
    if (license_section.any?) 
      license_section.remove
    end
    if (config && config[:license_key])
      new_license_section = Nokogiri::XML(File.new("/tmp/license.xml"))
      input.root.xpath("//server").first.add_child new_license_section.root
    end

    pipelines_section = input.root.xpath("//pipelines")
    if (pipelines_section.any?) 
      pipelines_section.remove
    end
    pipelines_section = Nokogiri::XML(File.new("/tmp/pipelines.xml"))
    input.root.add_child pipelines_section.root

    File.open(filename, 'w') {|f| f.write(input.to_xml) }
  end
end