VAGRANT_APP_NAME   = 'feeder'
HOSTNAME           = 'feeder.local'
HOSTNAME_ALIASES   = []
VAGRANT_IP         = '192.168.99.101'
VAGRANT_MEMORY_MB  = 2048
VAGRANT_CPUS       = 2
VAGRANT_BOX        = 'bento/ubuntu-16.04'

VAGRANT_PORTS = {
  puma: { guest: 3000, host: 3000 },
  webpack_dev_server: { guest: 8080, host: 8080 },
  postgres: { guest: 5432, host: 5432 }
}

Vagrant.require_version '>= 1.9'

REQUIRED_PLUGINS = [
  ['vagrant-vbguest', '0.14.2'],
  ['vagrant-hostmanager', '1.8.6']
].freeze

def require_plugins!(plugins)
  plugins = plugins.reject { |p| Vagrant.has_plugin?(p.first) }
  plugins.each do |plugin, version|
    next if Vagrant.has_plugin?(plugin)
    system(install_plugin_command(plugin, version)) || exit!
  end
  exit system('vagrant', *ARGV) unless plugins.empty?
end

def install_plugin_command(plugin, version = nil)
  [].tap do |a|
    a << 'vagrant plugin install'
    a << plugin
    a << "--plugin-version #{version}" if version
  end.join(' ')
end

require_plugins!(REQUIRED_PLUGINS)

Vagrant.configure('2') do |config|
  config.vm.provider :virtualbox do |vb, _override|
    vb.memory = Integer(VAGRANT_MEMORY_MB)
    vb.cpus = Integer(VAGRANT_CPUS)
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['guestproperty', 'set', :id, '--timesync-threshold', 10000]
    vb.gui = false
  end

  config.vbguest.auto_update = false

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.synced_folder '.', '/app', fsnotify: true,
    exclude: ['.git/', 'node_modules/', 'tmp/', 'coverage/']

  config.vm.synced_folder '../feeder-ansible', '/ansible'
  config.vm.synced_folder '../feeder-ansible-secrets', '/secrets'

  config.vm.define VAGRANT_APP_NAME do |machine|
    config.vm.box = VAGRANT_BOX
    machine.vm.hostname = HOSTNAME

    VAGRANT_PORTS.values.each do |ports|
      machine.vm.network('forwarded_port', auto_correct: true, **ports)
    end

    machine.vm.network 'private_network', ip: VAGRANT_IP
    machine.hostmanager.aliases = HOSTNAME_ALIASES
    config.vm.provision :shell, path: 'provision.sh', privileged: false
  end

  config.ssh.forward_agent = true

  # Prevent tty errors
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end
