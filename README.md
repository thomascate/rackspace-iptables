# rackspace-iptables cookbook

# Usage
This cookbook will apply iptables rules to your environment based on a datastructure stored in the following location.  
  
node['rackspace-iptables']['chains']

# Attributes
There are five chains that will be iterated over when the template is written. Each chain contains key/value pairs that
represent the rule and the weight of each iptables entry. The rule is a string that will match an entry in their iptables config on disk. You can see how these rules should look by running 'iptables-save' on your server. The weight is the order they will be entered into the config. The higher the weight the earlier the rule will be interpeted.
  
An example rule would be 
"-A INPUT -s 192.168.0.1/32 -i eth0 -j ACCEPT" => 100
Which would enter that rule above any iptables rule with a weight of <100.

These are the chains that are currently read by this cookbook.

default['rackspace-iptables']['chains']['INPUT'] = {}
default['rackspace-iptables']['chains']['OUTPUT'] = {}
default['rackspace-iptables']['chains']['FORWARD'] = {}
default['rackspace-iptables']['chains']['PREROUTING'] = {}
default['rackspace-iptables']['chains']['POSTROUTING'] = {}

# Author

Author:: Thomas Cate (thomas.cate@rackspace.com)
