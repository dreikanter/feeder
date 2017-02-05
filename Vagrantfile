ENV['APP_NAME']               ||= 'feeder'
ENV['HOST_NAME']              ||= "#{ENV['APP_NAME']}.dev"

ENV['VM_IP']                  ||= '192.168.99.99'
ENV['VM_MEMORY_MB']           ||= '2024'
ENV['VM_CPUS']                ||= '1'

ENV['LOCAL_ANSIBLE_PATH']     ||= '../rails-ansible'
ENV['LOCAL_SECRETS_PATH']     ||= '../rails-ansible-secrets'

ENV['APP_MOUNT_PATH']         ||= "/app"
ENV['ANSIBLE_MOUNT_PATH']     ||= "/ansible"
ENV['APP_SECRETS_MOUNT_PATH'] ||= "/secrets"

Vagrant.require_version '>= 1.5'

#
# Vagrant plugins setup
#

REQUIRED_PLUGINS = [
  ['vagrant-bindfs', '1.0.1'],
  ['vagrant-vbguest', '0.13.0'],
  ['vagrant-hostmanager', '1.8.5']
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

#
# VM setup
#

Vagrant.configure('2') do |config|
  config.vm.provider :virtualbox do |vb, _override|
    vb.memory = Integer(ENV['VM_MEMORY_MB'])
    vb.cpus = Integer(ENV['VM_CPUS'])
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # Mount application directory
  config.vm.synced_folder '.', '/var/app'
  config.bindfs.bind_folder '/var/app', ENV['APP_MOUNT_PATH']

  # Mount Ansible playbooks directory
  config.vm.synced_folder ENV['LOCAL_ANSIBLE_PATH'], '/var/ansible'
  config.bindfs.bind_folder '/var/ansible', ENV['ANSIBLE_MOUNT_PATH']

  # Mount application secrets directory
  config.vm.synced_folder ENV['LOCAL_SECRETS_PATH'], '/var/secrets'
  config.bindfs.bind_folder '/var/secrets', ENV['APP_SECRETS_MOUNT_PATH'], perms: '0700'
  # NOTE: Reduced permissions required for SSH keys to work properly

  config.vm.define ENV['APP_NAME'] do |machine|
    config.vm.box = 'bento/ubuntu-16.04'
    machine.vm.hostname = ENV['HOST_NAME']

    machine.vm.network 'forwarded_port', guest: 3000, host: 3000, auto_correct: true
    machine.vm.network 'forwarded_port', guest: 1080, host: 1080, auto_correct: true
    machine.vm.network 'forwarded_port', guest: 2812, host: 2812, auto_correct: true
    machine.vm.network 'private_network', ip: ENV['VM_IP']

    # Auxiliary domain names to create
    # machine.hostmanager.aliases = %W(
    #   admin.#{ENV['HOST_NAME']}
    # )

    # Ansible will run [provisioning_path] playbook on the guest system
    machine.vm.provision :ansible_local do |ansible|
      ansible.verbose = true
      ansible.install = true
      ansible.version = '2.2'
      ansible.provisioning_path = ENV['ANSIBLE_MOUNT_PATH']
      ansible.limit = 'all'
      ansible.playbook = 'provision_vagrant.yml'
      ansible.inventory_path = 'inventory/vagrant'
    end
  end

  config.ssh.forward_agent = true
end
