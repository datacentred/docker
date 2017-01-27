class profile::openstack::aodh {

  include ::aodh
  include ::aodh::keystone::authtoken
  include ::aodh::auth
  include ::aodh::api
  include ::aodh::evaluator
  include ::aodh::listener
  include ::aodh::notifier
  include ::aodh::wsgi::apache
  include ::aodh::config

  file { '/var/log/apache2/aodh_wsgi_access.log':
    target  => '/dev/stdout',
    require => Package['httpd'],
  }

  file { '/var/log/apache2/aodh_wsgi_error.log':
    target  => '/dev/stderr',
    require => Package['httpd'],
  }

  file { '/var/log/apache2/error.log':
    target  => '/dev/stderr',
    require => Package['httpd'],
  }

}
