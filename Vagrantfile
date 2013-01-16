Vagrant::Config.run do |config|

  config.vm.define :svnhg do |svnhg_config|
    svnhg_config.vm.box = "precise64"
    svnhg_config.vm.host_name = "svnhg.local"
    svnhg_config.vm.provision  :puppet do  |puppet|
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "svnhg.pp"
      #puppet.module_path = "puppet/modules"
    end
  end

end