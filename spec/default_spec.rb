require 'spec_helper'

describe 'rackspace_iptables::default' do

  context 'Ubuntu 12.04' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_iptables']['config']['chains']['INPUT']['-s 127.0.0.1 -j ACCEPT']['weight'] = -1
        node.set['rackspace_iptables']['config']['chains']['INPUT']['-s 127.0.0.1 -j DROP']['weight'] = 1
        node.set['rackspace_iptables']['config']['chains']['INPUT']['-s 127.0.0.1 -j DROP']['comment'] = 'bar'
      end.converge(described_recipe)
    end

    it 'disables ufw' do
      expect(chef_run).to disable_service('ufw')
    end

    it 'installs iptables-persistent package' do
      expect(chef_run).to install_package('iptables-persistent')
    end

    it 'enables iptables-persistent service' do
      expect(chef_run).to enable_service('iptables-persistent')
    end

    it 'sets rules in the correct order' do
      expect(chef_run).to render_file('/etc/iptables/rules.v4')
                    .with_content('-A INPUT -s 127.0.0.1 -j DROP -m comment --comment "bar"
-A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment ""')
    end
  end

  context 'Debian 7.2' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'debian', version: '7.2') do |node|
        node.set['rackspace_iptables']['config']['chains']['INPUT']['-s 127.0.0.1 -j ACCEPT']['weight'] = -1
        node.set['rackspace_iptables']['config']['chains']['INPUT']['-s 127.0.0.1 -j DROP']['weight'] = 1
        node.set['rackspace_iptables']['config']['chains']['INPUT']['-s 127.0.0.1 -j DROP']['comment'] = 'bar'
      end.converge(described_recipe)
    end

    it 'disables ufw' do
      expect(chef_run).to disable_service('ufw')
    end

    it 'installs iptables-persistent package' do
      expect(chef_run).to install_package('iptables-persistent')
    end

    it 'enables iptables-persistent service' do
      expect(chef_run).to enable_service('iptables-persistent')
    end

    it 'sets rules in the correct order' do
      expect(chef_run).to render_file('/etc/iptables/rules.v4')
                    .with_content('-A INPUT -s 127.0.0.1 -j DROP -m comment --comment "bar"
-A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment ""')
    end
  end
  context 'CentOS 6.4' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: '6.4') do |node|
        node.set['rackspace_iptables']['config']['chains']['INPUT']['-s 127.0.0.1 -j ACCEPT']['weight'] = -1
        node.set['rackspace_iptables']['config']['chains']['INPUT']['-s 127.0.0.1 -j DROP']['weight'] = 1
        node.set['rackspace_iptables']['config']['chains']['INPUT']['-s 127.0.0.1 -j DROP']['comment'] = 'bar'
      end.converge(described_recipe)
    end

    it 'enables iptables service' do
      expect(chef_run).to enable_service('iptables')
    end

    it 'sets rules in the correct order' do
      expect(chef_run).to render_file('/etc/sysconfig/iptables')
                      .with_content('-A INPUT -s 127.0.0.1 -j DROP -m comment --comment "bar"
-A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment ""')
    end
  end
end
