# == Class: ::profile::openstack::horizon
#
# Build the OpenStack Dashboard
#
class profile::openstack::horizon {
  include ::horizon
  include ::branding::horizon
}
