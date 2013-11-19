Vagrant.configure("2") do |config|
  config.vm.box = "heroku"
  config.vm.box_url = "https://dl.dropboxusercontent.com/s/auq7ipsbwgzmp9a/heroku.box"
  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.network :forwarded_port, guest: 5000, host: 5000
end
