include firewalld
include java

class { 'kibana':
  config  => {
    'server.host'            => $ipaddress,
    'xpack.security.enabled' => false,
  },
  require => Class['java'],
}

kibana_plugin { 'x-pack' : }

firewalld::custom_service { 'kibana':
  short       => $name,
  port        => [{
    'port'     => '5601',
    'protocol' => 'tcp',
  }],
  destination => {
    'ipv4' => '0.0.0.0/0',
  },
}

firewalld_service { 'kibana':
  ensure  => present,
  service => 'kibana',
  zone    => 'public',
}
