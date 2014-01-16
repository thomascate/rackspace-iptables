#
# Cookbook Name:: rackspace-iptables
#
# Copyright 2013 Rackspace
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if platform_family?(%w{debian})

  service "ufw" do
  	action :disable
  end

  package "iptables-persistent" do
    action :install
  end

  service "iptables-persistent" do
    action :enable
  end

  template "/etc/iptables/rules.v4" do
    cookbok node[:'rackspace-iptables'][:templates_cookbook][:rules]
    source "iptables.rules.erb"
    owner "root"
    group "root"
    mode "0600"
    variables lazy{{
      :INPUT => node[:'rackspace-iptables'][:config][:chains][:INPUT],
      :OUTPUT => node[:'rackspace-iptables'][:config][:chains][:OUTPUT],
      :FORWARD => node[:'rackspace-iptables'][:config][:chains][:FORWARD],
      :PREROUTING => node[:'rackspace-iptables'][:config][:chains][:PREROUTING],
      :POSTROUTING => node[:'rackspace-iptables'][:config][:chains][:POSTROUTING]
    }}
    notifies :restart, "service[iptables-persistent]"
  end

elsif platform_family?(%w{rhel})

  service "iptables" do
    action :enable
  end

  template "/etc/sysconfig/iptables" do
    cookbok node[:'rackspace-iptables'][:templates_cookbook][:rules]
    source "iptables.rules.erb"
    owner "root"
    group "root"
    mode "0600"
    variables lazy{{
      :INPUT => node[:'rackspace-iptables'][:config][:chains][:INPUT],
      :OUTPUT => node[:'rackspace-iptables'][:config][:chains][:OUTPUT],
      :FORWARD => node[:'rackspace-iptables'][:config][:chains][:FORWARD],
      :PREROUTING => node[:'rackspace-iptables'][:config][:chains][:PREROUTING],
      :POSTROUTING => node[:'rackspace-iptables'][:config][:chains][:POSTROUTING]
    }}
    notifies :restart, "service[iptables]"
  end

end