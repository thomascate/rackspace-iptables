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

  template "/etc/network/if-pre-up.d/iptablesload" do
  	source "iptablesload.erb"
  	owner "root"
  	owner "root"
  	mode "0700"
  end

  template "/etc/network/if-pre-up.d/iptablessave" do
  	source "iptablessave.erb"
  	owner "root"
  	owner "root"
  	mode "0700"
  end

  execute "iptablesload" do
    command "/etc/network/if-pre-up.d/iptablesload"
    action :nothing
  end

  template "/etc/iptables.rules" do
    source "iptables.rules.erb"
    owner "root"
    group "root"
    mode "0600"
    notifies :run, "execute[iptablesload]"
  end

end