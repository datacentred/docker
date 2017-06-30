class profile::openstack::aodh {

  include ::aodh
  include ::aodh::keystone::authtoken
  include ::aodh::auth
  include ::aodh::api
  include ::aodh::evaluator
  include ::aodh::listener
  include ::aodh::notifier
  include ::aodh::config

}
