#
# == Class: profile::openstack::glance
#
class profile::openstack::glance {
  include ::dc_openstack::ini
  include ::glance::api
  include ::glance::api::authtoken
  include ::glance::registry
  include ::glance::registry::authtoken
  include ::glance::notify::rabbitmq
  include ::glance::policy
  include ::glance::backend::rbd
  include ::ceph

  Class[::ceph] -> Class['::glance::backend::rbd']

  # TODO: Remove this hack once packages for Ceph 10.2.4 are
  # available - see https://bugs.launchpad.net/ubuntu/+source/ceph/+bug/1625489
  #
  package { 'python-glance-store':
    ensure => 'present',
  } ->
  file { 'rbd.py':
    path   => '/usr/lib/python2.7/dist-packages/glance_store/_drivers/rbd.py',
    source => 'puppet:///modules/dc_openstack/rbd.py',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/usr/local/etc/glance/':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { 'property_pr_rules':
    path   => '/usr/local/etc/glance/property_pr_rules',
    source => 'puppet:///modules/dc_openstack/property_pr_rules',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  glance_api_config { 'DEFAULT/property_protection_file' :
    value => '/usr/local/etc/glance/property_pr_rules',
  }

  glance_api_config { 'DEFAULT/property_protection_rule_format' :
    value => 'roles',
  }

}
