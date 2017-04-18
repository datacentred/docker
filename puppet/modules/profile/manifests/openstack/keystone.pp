# == Class: ::profile::openstack::keystone
#
class profile::openstack::keystone {

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

$path = { 'path' => '/etc/keystone/keystone-paste.ini' }
$entries = {
  'filter:healthcheck'  => {
    'paste.filter_factory' => {
      'value'   => 'oslo_middleware:Healthcheck.factory',
      'require' => Package['keystone']
    },
    'backends'             => {
      'value'   => 'disable_by_file',
      'require' => Package['keystone']
    },
    'disable_by_file_path' => {
      'value'   => '/etc/keystone/healthcheck_disable',
      'require' => Package['keystone'],
    }
  },
  'pipeline:public_api' => {
    'pipeline' => {
      'value'   => 'healthcheck cors sizelimit url_normalize request_id admin_token_auth build_auth_context token_auth json_body ec2_extension public_service',
      'require' => Package['keystone'],
    }
  },
  'pipeline:admin_api' => {
    'pipeline' => {
      'value'   => 'healthcheck cors sizelimit url_normalize request_id admin_token_auth build_auth_context token_auth json_body ec2_extension s3_extension admin_service',
      'require' => Package['keystone'],
    }
  },
  'pipeline:api_v3' => {
    'pipeline' => {
      'value'   => 'healthcheck cors sizelimit url_normalize request_id admin_token_auth build_auth_context token_auth json_body ec2_extension_v3 s3_extension service_v3',
      'require' => Package['keystone'],
    }
  },
  'pipeline:public_version_api' => {
    'pipeline' => {
      'value'   => 'healthcheck cors sizelimit url_normalize public_version_service',
      'require' => Package['keystone'],
    }
  },
  'pipeline:admin_version_api' => {
    'pipeline' => {
      'value'   => 'healthcheck cors sizelimit url_normalize admin_version_service',
      'require' => Package['keystone'],
    }
  }
}
create_ini_settings($entries, $path)
}
