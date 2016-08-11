# == Class: ::profile::openstack::keystone
#
class profile::openstack::keystone {

  include ::keystone
  include ::keystone::wsgi::apache

}
