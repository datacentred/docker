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

  # TODO: Remove these hacky workarounds once we're at a version of OpenStack that's
  # properly supported by puppet-nova
  nova_config {
    'default/network_api_class':            value => 'nova.network.neutronv2.api.API';
    'default/linuxnet_interface_driver':    value => 'nova.network.linux_net.LinuxBridgeInterfaceDriver';
    'keystone_authtoken/auth_plugin':       value => 'password';
    'keystone_authtoken/admin_user':        value => 'nova';
    'keystone_authtoken/admin_tenant_name': value => 'services';
    'keystone_authtoken/admin_password':    value => hiera('keystone_nova_password');
    'neutron/auth_plugin':                  value => 'password';
    'neutron/admin_user':                   value => 'neutron';
    'neutron/admin_tenant_name':            value => 'services';
    'neutron/admin_password':               value => hiera('keystone_neutron_password');
    'neutron/identity_uri':                 value => "https://${hiera('os_api_host')}:35357";
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
