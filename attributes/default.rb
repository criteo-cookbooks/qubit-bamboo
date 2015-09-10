default['qubit_bamboo']['home']    = '/opt/bamboo'
default['qubit_bamboo']['version'] = '0.2.14'

default['qubit_bamboo']['flags']['config'] = "#{node['qubit_bamboo']['home']}/production.json"
default['qubit_bamboo']['flags']['log']    = '/var/log/bamboo-server.log'

default['qubit_bamboo']['config']['Marathon']['Endpoint'] = 'http://localhost:8080'

default['qubit_bamboo']['config']['Bamboo']['Endpoint'] = 'http://localhost:8000'
default['qubit_bamboo']['config']['Bamboo']['Zookeeper']['Host'] = 'localhost'
default['qubit_bamboo']['config']['Bamboo']['Zookeeper']['Path'] = '/bamboo'
default['qubit_bamboo']['config']['Bamboo']['Zookeeper']['ReportingDelay'] = 5

default['qubit_bamboo']['config']['HAProxy']['TemplatePath']  = "#{node['qubit_bamboo']['home']}/haproxy_template.cfg"
default['qubit_bamboo']['config']['HAProxy']['OutputPath']    = '/etc/haproxy/haproxy.cfg'
default['qubit_bamboo']['config']['HAProxy']['ReloadCommand'] = 'haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -D -sf $(cat /var/run/haproxy.pid)'

default['qubit_bamboo']['config']['StatsD']['Enabled'] = false
default['qubit_bamboo']['config']['StatsD']['Host']    = 'localhost:8125'
default['qubit_bamboo']['config']['StatsD']['Prefix']  = 'bamboo'
