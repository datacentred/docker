# Class: profile::openstack::heat
#
# OpenStack Orchestration
#
class profile::openstack::heat {

  include ::heat
  include ::heat::keystone::authtoken
  include ::heat::keystone::domain
  include ::heat::engine
  include ::heat::api
  include ::heat::api_cfn

}
