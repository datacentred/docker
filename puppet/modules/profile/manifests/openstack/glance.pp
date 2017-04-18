#
# == Class: profile::openstack::glance
#
class profile::openstack::glance {
  include ::glance::api
  include ::glance::api::authtoken
  include ::glance::registry
  include ::glance::registry::authtoken
  include ::glance::notify::rabbitmq
  include ::glance::policy
  include ::glance::backend::rbd
  include ::ceph

  Class[::ceph] -> Class['::glance::backend::rbd']

  # TODO: Remove this hack once packages for Ceph 10.2.4 are
  # available - see https://bugs.launchpad.net/ubuntu/+source/ceph/+bug/1625489
  #
  package { 'python-glance-store':
    ensure => 'present',
  } ->
  file { 'rbd.py':
    path   => '/usr/lib/python2.7/dist-packages/glance_store/_drivers/rbd.py',
    source => 'puppet:///modules/dc_openstack/rbd.py',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/usr/local/etc/glance/':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { 'property_pr_rules':
    path   => '/usr/local/etc/glance/property_pr_rules',
    source => 'puppet:///modules/dc_openstack/property_pr_rules',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  glance_api_config { 'DEFAULT/property_protection_file' :
    value => '/usr/local/etc/glance/property_pr_rules',
  }

  glance_api_config { 'DEFAULT/property_protection_rule_format' :
    value => 'roles',
  }

  glance_api_paste_ini { 'pipeline:glance-api/pipeline' :
    value => 'healthcheck cors versionnegotiation osprofiler unauthenticated-context rootapp',
  }

  glance_api_paste_ini { 'pipeline:glance-api-caching/pipeline' :
    value => 'healthcheck cors versionnegotiation osprofiler unauthenticated-context cache rootapp',
  }

  glance_api_paste_ini { 'pipeline:glance-api-cachemanagement/pipeline' :
    value => 'healthcheck cors versionnegotiation osprofiler unauthenticated-context cache cachemanage rootapp',
  }

  glance_api_paste_ini { 'pipeline:glance-api-keystone/pipeline' :
    value => 'healthcheck cors versionnegotiation osprofiler authtoken context  rootapp',
  }

  glance_api_paste_ini { 'pipeline:glance-api-keystone+caching/pipeline' :
    value => 'healthcheck cors versionnegotiation osprofiler authtoken context cache rootapp',
  }

  glance_api_paste_ini { 'pipeline:glance-api-keystone+cachemanagement/pipeline' :
    value => 'healthcheck cors versionnegotiation osprofiler authtoken context cache cachemanage rootapp',
  }

  glance_api_paste_ini { 'pipeline:glance-api-trusted-auth/pipeline' :
    value => 'healthcheck cors versionnegotiation osprofiler context rootapp',
  }

  glance_api_paste_ini { 'pipeline:glance-api-trusted-auth+cachemanagement/pipeline' :
    value => 'healthcheck cors versionnegotiation osprofiler context cache cachemanage rootapp',
  }

  glance_api_paste_ini { 'filter:healthcheck/paste.filter_factory' :
    value => 'oslo_middleware:Healthcheck.factory',
  }

  glance_api_paste_ini { 'filter:healthcheck/backends' :
    value => 'disable_by_file',
  }

  glance_api_paste_ini { 'filter:healthcheck/disable_by_file_path' :
    value => '/etc/glance/healthcheck_disable',
  }

  glance_registry_paste_ini { 'pipeline:glance-registry-trusted-auth/pipeline' :
    value => 'healthcheck osprofiler context registryapp',
  }

  glance_registry_paste_ini { 'pipeline:glance-registry/pipeline' :
    value => 'healthcheck osprofiler unauthenticated-context registryapp',
  }

  glance_registry_paste_ini { 'pipeline:glance-registry-keystone/pipeline' :
    value => 'healthcheck osprofiler authtoken context registryapp',
  }

  glance_registry_paste_ini { 'filter:healthcheck/paste.filter_factory' :
    value => 'oslo_middleware:Healthcheck.factory',
  }

  glance_registry_paste_ini { 'filter:healthcheck/backends' :
    value => 'disable_by_file',
  }

  glance_registry_paste_ini { 'filter:healthcheck/disable_by_file_path' :
    value => '/etc/glance/healthcheck_disable',
  }

}
