# == Class: ::profile::openstack::keystone
#
class profile::openstack::keystone {

  include ::dc_openstack::ini
  include ::keystone
  include ::keystone::wsgi::apache

  file_line { 'keystone_nofiles':
    path    => '/etc/init/keystone.conf',
    line    => 'limit nofile 4096 65536',
    require => Package['keystone'],
  }

  file { '/var/log/apache2/keystone_wsgi_main_access.log':
    target  => '/dev/stdout',
    require => Package['httpd'],
  }

  file { '/var/log/apache2/keystone_wsgi_main_error.log':
    target  => '/dev/stderr',
    require => Package['httpd'],
  }

  file { '/var/log/apache2/keystone_wsgi_admin_access.log':
    target  => '/dev/stdout',
    require => Package['httpd'],
  }

  file { '/var/log/apache2/keystone_wsgi_admin_error.log':
    target  => '/dev/stderr',
    require => Package['httpd'],
  }

  file { '/var/log/apache2/error.log':
    target  => '/dev/stderr',
    require => Package['httpd'],
  }

}
