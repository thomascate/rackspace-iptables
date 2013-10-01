# rackspace-iptables cookbook

# Usage
This cookbook creates a template that will loop over an array that fills in sections of an iptables config template.

# Attributes
This is a very simple cookbook that stores iptables rules in an array of strings so that iptables can easily be managed on mulitple hosts.
node['rackspace-iptables']['rules']

# Author

Author:: Thomas Cate (thomas.cate@rackspace.com)
