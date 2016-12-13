#
# == Class: ::profile::openstack::neutron
#
class profile::openstack::neutron {
  include ::neutron
  include ::neutron::server
  include ::neutron::keystone::authtoken
  include ::neutron::server::notifications
  include ::neutron::plugins::ml2
  include ::neutron::quota
}
