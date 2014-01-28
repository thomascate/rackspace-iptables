#
# Cookbook Name:: rackspace_iptables
# Library:: helpers
#
# Copyright 2014, Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module RackspaceIptables
  # convenience functions for building iptables rules in Rolebooks
  module Helpers
    # find servers to/from which to configure access
    def add_iptables_rule(chain, rule, weight=50, comment=nil)
      node.default['rackspace_iptables']['config']['chains'][chain][rule]['weight'] = weight
      node.default['rackspace_iptables']['config']['chains'][chain][rule]['comment'] = comment if comment
    end

    def search_add_iptables_rules(search_str, chain, rules_to_add, weight=50, comment=search_str)
      unless Chef::Config['solo']
        rules = {}
        nodes = search('node', search_str) || []
        nodes.map! do |member|
          server_ip = begin
            if member.attribute?('cloud')
              if node.attribute?('cloud') && (member['cloud']['provider'] == node['cloud']['provider'])
                member['cloud']['local_ipv4']
              else
                member['cloud']['public_ipv4']
              end
            else
              member['ipaddress']
            end
          end
	  # when passing a single rule, user may use a string instead of an array
          rules_to_add = [rules_to_add] if rules_to_add.class == String
          rules_to_add.each do |rule|
            rules["-s #{server_ip}/32 " << rule] = {comment: comment, weight: weight}
	  end
	end
	rules.each { |rule,val| node.default['rackspace_iptables']['config']['chains'][chain][rule] = val }
      else
        Chef::Log.warn "Running Chef Solo; doing nothing for function call to add_rules_for_nodes"
      end
    end
  end
end

Chef::Recipe.send(:include, ::RackspaceIptables::Helpers)
Chef::Resource.send(:include, ::RackspaceIptables::Helpers)
Chef::Provider.send(:include, ::RackspaceIptables::Helpers)
