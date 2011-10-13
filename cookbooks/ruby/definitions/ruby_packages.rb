define :ruby_packages, :action => :install do
  ruby_version = "ruby-#{params[:version]}"
  ruby_download_path = "#{ruby_version}.tar.gz"
  ruby_download = "/tmp/#{ruby_download_path}"
  
  execute "download ruby" do
    command "wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/#{ruby_download_path} -O #{ruby_download}"
    not_if "test -f #{ruby_download}"
  end
  bash "install ruby" do
    code <<-EOH
    tar -zxvf #{ruby_download}
    cd #{ruby_version}
    ./configure --with-openssl-dir=/usr/lib/openssl ; make
    make install
    EOH
  end
  bash "replace system ruby" do
    code <<-EOH
    ln -sf /usr/local/bin/ruby /usr/bin/ruby
    EOH
  end
end
