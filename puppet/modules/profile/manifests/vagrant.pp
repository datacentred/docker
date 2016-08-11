# == Class: ::profile::vagrant
#
# Workaround for containers that need to play nicely
# in a Vagrant virtual environment
#
class profile::vagrant {

  host { 'compute.datacentred.io':
    ip => hiera(os_api_ip)
  }

}
