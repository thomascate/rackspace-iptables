## rackspace_iptables cookbook

The rackspace_iptables cookbook manages all iptables rules for a node. The user adds rules by including the rackspace_iptables default recipe in some node-specific or environment-specific recipe (i.e. a 'rolebook') and defining rules via the data structure `node['rackspace_iptables']['config']['chains']`. If a user includes this cookbook but does not define any rules, the default recipe will overwrite existing iptables configuration with an empty rule list.

Obviously this cookbook should not be used in environments where iptables is managed by other means (e.g. RackConnect).

Requirements
--------
Chef version 0.11.6+.

### Platforms
This cookbook has been tested on:

* Debian 7.2
* Ubuntu 12.04
* CentOS 6.4

It may or may not behave as expected on other versions of these distributions.

### Cookbooks
This cookbook has no dependencies.

Usage
--------
### Include the default recipe and define in metadata
Some recipe in your run list must include the iptables recipe:

`include_recipe 'rackspace_iptables'`

You must also add a `depends` line in the metadata for your cookbook.

### Define rules
There are a few different ways to add iptables rules to your node, but they all work by building the data structure `node['rackspace_iptables']['config']['chains']`. The data structure contains five hashes from which this cookbook will build a node's rules file: 'INPU'T, 'OUTPUT', 'FORWARD', 'PREROUTING', and 'POSTROUTING'.

##### manual definition
You may manually add rules to the data structure in the following way:

`node['rackspace_iptables']['config']['chains']['INPUT']['-s 10.0.0.1 -p tcp --dport 22 -j ACCEPT'] = { weight: 50, comment: 'allow ssh' }`

At a minimum you must define a weight for each rule; this is what the cookbook uses to order the rules. Rules with a higher weight will appear *before* rules with a lower weight. Rule comments are optional.

For example, if you define the following two rules:

```
node['rackspace_iptables']['config']['chains']['INPUT']['-s 10.0.0.1 -p tcp --dport 22 -j ACCEPT'] = { weight: 50, comment: 'allow ssh' }
node['rackspace_iptables']['config']['chains']['INPUT']['-s 10.0.0.1 -p tcp --dport 21 -j ACCEPT'] = { weight: 51 }
```

they will be written to the iptables rules file as follows:

```
-A INPUT -s 10.0.0.1 -p tcp --dport 21 -j ACCEPT
-A INPUT -s 10.0.0.1 -p tcp --dport 22 -j ACCEPT -m comment --comment "allow ssh"
```

##### convenience function
You may use the following function to more succinctly define rules:

`add_iptables_rule('INPUT', '-s 10.0.0.1 -p tcp --dport 22 -j ACCEPT', 50, 'allow ssh')`

As with manual specifications, you may omit comments. Unlike manual specifications, you may also omit weight:

```
add_iptables_rule('INPUT', '-s 10.0.0.1 -p tcp --dport 22 -j ACCEPT')
add_iptables_rule('INPUT', '-s 10.0.0.1 -p tcp --dport 21 -j ACCEPT', 51)
```

The function will use a *default weight of 50* for calls that do not pass in a weight, so from the example above, the cookbook will add the two rules in same order as in the example for manual definitions (port 21 rule appears first).

Note that you cannot include a comment while ommitting weight.

##### search for nodes 
Oftentimes you will want to allow access to/from other specific nodes controlled by your Chef server. There is also a convenience function for this:

`search_add_iptables_rules('node:*web*', 'INPUT', '-p tcp --dport 3306 -j ACCEPT', 70, 'web nodes')`

This will perform a Chef `search` for all nodes whose names match `*web*`. If the search returns two nodes whose IP addresses are 1.1.1.1 and 1.1.1.2, the cookbook will add the following two rules:

```
-A INPUT -s 1.1.1.1 -p tcp --dport 3306 -j ACCEPT -m comment --comment "web nodes"
-A INPUT -s 1.1.1.2 -p tcp --dport 3306 -j ACCEPT -m comment --comment "web nodes"
```

Note that these rules will have the same weight as each other (70), and so the cookbook may produce them in any order relative to each other. In a common scenario, you may want to supplement these rules with one that denies MySQL access to any other nodes. You would accomplish this by defining a rule with weight < 70 (manually or using `add_iptables_rule`) that denies connections to port 3306.

If you want to add multiple rules for each node returned in a search, you may pass an array of rules to the function rather than a single string:

`search_add_iptables_rules('node:*web*', 'INPUT', ['-p tcp --dport 3306 -j ACCEPT', '-p tcp --dport 22 -j ACCEPT'], 70, 'web nodes')`

This avoids searching the Chef server an unnecessary number of times.

---
Please read the `add_iptables_rule` and `search_add_iptables_rules` functions in `libraries/helpers.rb` to determine if they satisfy your use case. If not, you can manually define your rules.

Recipes
--------
### default

* Uninstalls 'ufw' if installed (e.g. on Ubuntu)
* Installs iptables packages if not installed
* Builds the iptables rules file from `node['rackspace_iptables']['config']['chains']`
* Loads iptables rules if not loaded or if the rules file has changed

License & Authors
------------

Author:: Thomas Cate (thomas.cate@rackspace.com)
Author:: Kent Shultz (kent.shultz@rackspace.com)

```text
Copyright 2014, Rackspace, US Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
