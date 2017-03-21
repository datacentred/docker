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

  nova_config {
    'keystone_authtoken/auth_plugin':       value => 'password';
    'keystone_authtoken/admin_user':        value => 'nova';
    'keystone_authtoken/admin_tenant_name': value => 'services';
    'keystone_authtoken/admin_password':    value => hiera('keystone_nova_password');
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
