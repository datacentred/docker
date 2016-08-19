# == Class: ::profile::openstack::horizon
#
# Buld the OpenStack Dashboard
#
class profile::openstack::horizon {
  include ::horizon
  include ::branding::horizon

  Class['::horizon'] ->
  Class['::branding::horizon']
}
