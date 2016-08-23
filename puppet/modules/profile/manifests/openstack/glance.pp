# == Class: profile::openstack::glance
#
class profile::openstack::glance {
  include ::glance::api
  include ::glance::registry
  include ::glance::notify::rabbitmq
  include ::glance::policy

  # TODO: Remove post-upgrade
  file_line { 'glance_api_auth_version':
    ensure  => absent,
    path    => '/etc/glance/glance-api.conf',
    line    => 'auth_version=V2.0',
    require => Package['glance-api'],
  }

  file_line { 'glance_registry_auth_version':
    ensure  => absent,
    path    => '/etc/glance/glance-registry.conf',
    line    => 'auth_version=V2.0',
    require => Package['glance-registry'],
  }

}
