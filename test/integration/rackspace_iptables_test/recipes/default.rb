include_recipe 'rackspace_iptables'

# manually add with weight and comment
node.default['rackspace_iptables']['config']['chains']['INPUT']['-s 10.0.0.1/32 -j ACCEPT'] = { weight: 1, comment: 'foo' }
# manually add with comment only
node.default['rackspace_iptables']['config']['chains']['INPUT']['-s 10.0.0.2/32 -j ACCEPT'] = { weight: 1 }

add_iptables_rule 'INPUT', '-s 10.0.0.4 -j ACCEPT'
add_iptables_rule 'INPUT', '-s 10.0.0.5 -j ACCEPT', 80
add_iptables_rule 'INPUT', '-s 10.0.0.6 -j ACCEPT', 70, 'foo2'

# search-add with comment and weight
search_add_iptables_rules('name:*', 'INPUT', '-p tcp --dport 22 -j ACCEPT', 70, 'all nodes ssh')
# search-add with comment only
search_add_iptables_rules('name:*', 'INPUT', '-p tcp --dport 80 -j ACCEPT', 30)
# search-add without comment or weight
search_add_iptables_rules('name:*', 'INPUT', '-p tcp --dport 443 -j ACCEPT')
