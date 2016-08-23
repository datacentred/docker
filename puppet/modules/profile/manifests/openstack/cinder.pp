# == Class: ::profile::openstack::cinder
#
#
class profile::openstack::cinder {
  include ::cinder
  include ::cinder
  include ::cinder::keystone::auth
  include ::cinder::api
  include ::cinder::scheduler
  include ::cinder::glance
  include ::cinder::quota
  include ::cinder::volume
  include ::cinder::backends
  include ::cinder::ceilometer

}
