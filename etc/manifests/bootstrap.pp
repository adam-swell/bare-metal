package { 'librarian-puppet':
  ensure   => latest,
  provider => puppet_gem,
}

file { '/usr/bin/librarian-puppet':
  ensure => link,
  target => '/opt/puppetlabs/puppet/bin/librarian-puppet',
}

file { '/usr/bin/puppet':
  ensure => link,
  target => '/opt/puppetlabs/bin/puppet',
}

$sudoers = @(END)
# Managed by puppet!

Defaults !visiblepw
Defaults always_set_home
Defaults match_group_by_gid
Defaults env_reset
Defaults env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS"
Defaults env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"
Defaults env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
Defaults env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"
Defaults env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"
Defaults secure_path = /sbin:/bin:/usr/sbin:/usr/bin

root ALL=(ALL) ALL

#includedir /etc/sudoers.d
END

file { '/etc/sudoers':
  mode    => '0440',
  content => inline_epp($sudoers),
}

file { '/etc/sudoers.d/wheel':
  owner   => 'root',
  group   => 'root',
  mode    => '0440',
  content => '%wheel ALL=(ALL) NOPASSWD: ALL',
}

service { [ 'NetworkManager', 'wpa_supplicant' ]:
  ensure => stopped,
  enable => false,
}
