include firewalld
include java

class { 'elasticsearch':
  restart_on_change => true,
  require           => Class['java'],
}

elasticsearch::instance { $hostname : 
  config => {
    'network.host' => '0.0.0.0',
    'xpack.security.enabled' => false,
  },
}

elasticsearch::plugin { 'x-pack':
  instances => $hostname,
}

firewalld::custom_service { 'elasticsearch':
  short       => $name,
  port        => [{
    'port'     => '9200',
    'protocol' => 'tcp',
  }, {
    'port'     => '9300',
    'protocol' => 'tcp',
  }],
  destination => {
    'ipv4'     => '0.0.0.0/0',
  },
}

firewalld_service { 'elasticsearch':
  ensure  => present,
  service => 'elasticsearch',
  zone    => 'public',
}
