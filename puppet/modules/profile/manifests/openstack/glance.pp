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

}
