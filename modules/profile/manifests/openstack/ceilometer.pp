class profile::openstack::ceilometer {

  include ::ceilometer
  include ::ceilometer::keystone::authtoken
  include ::ceilometer::api
  include ::ceilometer::wsgi::apache
  include ::ceilometer::agent::auth
  include ::ceilometer::agent::central
  include ::ceilometer::agent::notification
  include ::ceilometer::collector
  include ::ceilometer::expirer
  include ::ceilometer::db
  include ::ceilometer::config

  file { '/var/log/apache2/ceilometer_wsgi_access.log':
    target  => '/dev/stdout',
    require => Package['httpd'],
  }

  file { '/var/log/apache2/ceilometer_wsgi_error.log':
    target  => '/dev/stderr',
    require => Package['httpd'],
  }

  file { '/etc/ceilometer/event_definitions.yaml':
    ensure  => present,
    content => file('dc_openstack/event_definitions.yaml'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require =>  Class['::ceilometer::agent::notification'],
  }

  file { '/etc/ceilometer/pipeline.yaml':
    ensure  => present,
    content => file('dc_openstack/pipeline.yaml'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require =>  Class['::ceilometer::agent::notification'],
  }

}
