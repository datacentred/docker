#
# ==Class: ::profile::openstack::nova
#
class profile::openstack::nova {
  include ::dc_openstack::ini
  include ::nova
  include ::nova::api
  include ::nova::network::neutron
  include ::nova::cert
  include ::nova::conductor
  include ::nova::consoleauth
  include ::nova::scheduler
  include ::nova::scheduler::filter
  include ::nova::vncproxy

  # TODO: Remove these hacky workarounds once we're at a version of OpenStack that's
  # properly supported by puppet-nova
  nova_config {
    'keystone_authtoken/auth_url':            value => "https://${hiera('os_api_host')}:35357";
    'keystone_authtoken/auth_plugin':         value => 'password';
    'keystone_authtoken/project_domain_name': value => 'default';
    'keystone_authtoken/user_domain_name':    value => 'default';
    'keystone_authtoken/project_name':        value => 'services';
    'keystone_authtoken/username':            value => 'nova';
    'keystone_authtoken/password':            value => hiera('keystone_nova_password');
    'DEFAULT/memcached_servers':              value => join(hiera('memcached_servers'), ',');
    'DEFAULT/secure_proxy_ssl_header':        value => 'HTTP_X_FORWARDED_PROTO';
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

  file { '/usr/lib/python2.7/dist-packages/nova/scheduler/filters/aggregate_image_properties_isolation_dc.py':
    ensure  => present,
    content => file('dc_openstack/aggregate_image_properties_isolation_dc.py'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require =>  Package['python-nova'],
  }

}
