#
# == Class: ::profile::openstack::neutron
#
class profile::openstack::neutron {
  include ::neutron
  include ::neutron::server
  include ::neutron::server::notifications
  include ::neutron::plugins::ml2
  include ::neutron::quota

  ensure_packages(['python-neutron-lbaas','python-neutron-vpnaas'])

  # TODO: Remove these hacky workarounds once we're at a version of OpenStack that's
  # properly supported by puppet-nova
  neutron_config {
    'keystone_authtoken/auth_plugin':                          value => 'password';
    'keystone_authtoken/auth_url':                             value => "https://${hiera('os_api_host')}:35357";
    'keystone_authtoken/username':                             value => 'neutron';
    'keystone_authtoken/password':                             value => hiera('keystone_neutron_password');
    'keystone_authtoken/project_domain_name':                  value => 'default';
    'keystone_authtoken/user_domain_name':                     value => 'default';
    'keystone_authtoken/project_name':                         value => 'services';
    'nova/project_domain_name':                                value => 'default';
    'nova/user_domain_name':                                   value => 'default';
    'DEFAULT/enable_services_on_agents_with_admin_state_down': value => true;
    'DEFAULT/executor_thread_pool_size':                       value => '2048';
    'DEFAULT/rpc_conn_pool_size':                              value => '60';
  }

}
