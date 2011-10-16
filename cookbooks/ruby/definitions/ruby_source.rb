define :ruby_source, :action => :install do
  ruby_version = "ruby-#{params[:version].to_s}-#{params[:patch_level]}"
  ruby_major_version = ruby_version.match(/(\d).(\d)/).to_s
  ruby_download_path = "#{ruby_version}.tar.gz"
  ruby_download = "/tmp/#{ruby_download_path}"
  
  execute "download ruby" do
    command "wget ftp://ftp.ruby-lang.org/pub/ruby/#{ruby_major_version}/#{ruby_download_path} -O #{ruby_download}"
    not_if "test -f #{ruby_download}"
  end
  bash "install ruby" do
    code <<-EOH
    tar -zxvf #{ruby_download}
    cd #{ruby_version}
    ./configure --with-openssl-dir=/usr/lib/openssl ; make
    make install
    EOH
    not_if "ruby -v | grep \"#{params[:version]}\" | grep \"#{params[:patch_level]}\""
  end
  bash "replace system ruby" do
    code <<-EOH
    ln -sf /usr/local/bin/ruby /usr/bin/ruby
    EOH
  end
end
