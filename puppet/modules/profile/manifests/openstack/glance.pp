#
# == Class: profile::openstack::glance
#
class profile::openstack::glance {
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

}
