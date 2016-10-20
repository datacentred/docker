# == Class: ::profile::openstack::cinder
#
# Configure OpenStack's block storage service for
# deployment in a Docker container
#
class profile::openstack::cinder {

  include ::cinder
  include ::cinder::keystone::authtoken
  include ::cinder::api
  include ::cinder::scheduler
  include ::cinder::glance
  include ::cinder::quota
  include ::cinder::volume
  include ::cinder::backends
  include ::cinder::ceilometer
  include ::cinder::config
  include ::ceph

  $rbd_user        = 'cinder'
  $rbd_secret_uuid = '42991612-85dc-42e4-ae3c-49cf07e98b70'
  
  cinder::backend::rbd { 'cinder.volumes':
    rbd_pool        => 'cinder.volumes',
    rbd_user        => $rbd_user,
    rbd_secret_uuid => $rbd_secret_uuid,
    extra_options   => {
      'cinder.volumes/storage_availability_zone' => {
        'value' => 'Production',
      },
    },
  }
  
  cinder::backend::rbd { 'cinder.volumes.flash':
    rbd_pool        => 'cinder.volumes.flash',
    rbd_user        => $rbd_user,
    rbd_secret_uuid => $rbd_secret_uuid,
    extra_options   => {
      'cinder.volumes.flash/storage_availability_zone' => {
        'value' => 'Production',
      },
    },
  }

}

