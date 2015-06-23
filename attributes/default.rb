default['qubit_bamboo']['home'] = '/opt/bamboo'
default['qubit_bamboo']['version'] = '0.2.12'

default['qubit_bamboo']['config_path'] = "#{node['qubit_bamboo']['home']}/production.json"

default['qubit_bamboo']['log_path'] = '/var/log/bamboo-server.log'

default['qubit_bamboo']['config']['marathon_port'] = 8080
default['qubit_bamboo']['config']['marathon_hosts'] = ["http://localhost:#{node['qubit_bamboo']['config']['marathon_port']}"]

default['qubit_bamboo']['config']['port'] = 8000

default['qubit_bamboo']['config']['zk']['hosts'] = ['localhost']
default['qubit_bamboo']['config']['zk']['path'] = ''
default['qubit_bamboo']['config']['zk']['reporting_delay'] = 5

default['qubit_bamboo']['config']['haproxy']['template_path'] = "#{node['qubit_bamboo']['home']}/haproxy_template.cfg"
default['qubit_bamboo']['config']['haproxy']['output_path'] = '/etc/haproxy/haproxy.cfg'
default['qubit_bamboo']['config']['haproxy']['ReloadCommand'] = 'haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -D -sf $(cat /var/run/haproxy.pid)'

default['qubit_bamboo']['config']['statsd']['enabled'] = false
default['qubit_bamboo']['config']['statsd']['host'] = 'localhost'
default['qubit_bamboo']['config']['statsd']['port'] = 8125
default['qubit_bamboo']['config']['statsd']['prefix'] = 'bamboo'

default['qubit_bamboo']['config'] = {
  'Marathon' => {
    'Endpoint' => node['qubit_bamboo']['config']['marathon_hosts'].join(','),
  },
  'Bamboo' => {
    'Endpoint' => "http://#{node['ipaddress']}:#{node['qubit_bamboo']['config']['port']}",
    'Zookeeper' => {
      'Host' => node['qubit_bamboo']['config']['zk']['hosts'].join(','),
      'Path' => node['qubit_bamboo']['config']['zk']['path'],
      'ReportingDelay' => node['qubit_bamboo']['config']['zk']['reporting_delay'],
    },
  },
  'HAProxy' => {
    'TemplatePath' => node['qubit_bamboo']['config']['haproxy']['template_path'],
    'OutputPath' => node['qubit_bamboo']['config']['haproxy']['output_path'],
    'ReloadCommand' => node['qubit_bamboo']['config']['haproxy']['ReloadCommand'],
  },
  'StatsD' => {
    'Enabled' => node['qubit_bamboo']['config']['statsd']['enabled'],
    'Host' => "#{node['qubit_bamboo']['config']['statsd']['host']}:#{node['qubit_bamboo']['config']['statsd']['port']}",
    'Prefix' => node['qubit_bamboo']['config']['statsd']['prefix'],
  },
}
