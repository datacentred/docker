#
# ==Class: ::profile::openstack::nova
#
class profile::openstack::nova {
  include ::nova
  include ::nova::api
  include ::nova::network::neutron
  include ::nova::cert
  include ::nova::conductor
  include ::nova::consoleauth
  include ::nova::scheduler
  include ::nova::scheduler::filter
  include ::nova::vncproxy

  nova_config { 'DEFAULT/restrict_isolated_hosts_to_isolated_images':
    value => true,
  }

  package { 'iptables':
    ensure => present,
  }->
  file { ['/sbin/iptables-save', '/sbin/iptables-restore']:
    content => "#!/bin/sh\nexit 0",
    owner   => root,
    group   => root,
    mode    => '0770',
  }

}
