# == Class: ::profile::openstack::horizon
#
# Build the OpenStack Dashboard
#
class profile::openstack::horizon {
  include ::horizon
  include ::branding::horizon

  file { '/var/log/apache2/horizon_access.log':
    target  => '/dev/stdout',
    require => Package['httpd'],
  }

  file { '/var/log/apache2/horizon_error.log':
    target  => '/dev/stderr',
    require => Package['httpd'],
  }

  file { '/var/log/apache2/error.log':
    target  => '/dev/stderr',
    require => Package['httpd'],
  }

}
