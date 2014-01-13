# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # For a complete reference, please see the online documentation at
  # vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = 'heroku'
  config.vm.box_url = 'https://www.dropbox.com/s/tvxwobc83q4hlf5/heroku.box'
  config.vm.provision :shell, path: 'config/vagrant/bootstrap.sh'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:5000" will access port 5000 on the guest machine.
  config.vm.network :forwarded_port, guest: 5000, host: 5000
end
