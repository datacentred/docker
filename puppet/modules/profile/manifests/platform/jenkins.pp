#
# Class: profile::platform::jenkins
#
class profile::platform::jenkins {

  $docker_release = '1.13.1-rc2'

  ensure_packages('openssh-server')

  user { 'jenkins':
    ensure => present,
  }

  user { 'sshd':
    ensure     => present,
    home       => '/home/sshd',
    managehome => true,
    require    => Package['openssh-server'],
  }

  file_line { 'sshd_config':
    path    => '/etc/ssh/sshd_config',
    line    => 'UsePrivilegeSeparation no',
    match   => '^UsePrivilegeSeparation',
    require => Package['openssh-server'],
  }

  wget::fetch { 'download_docker_binaries':
    source      => "https://test.docker.com/builds/Linux/x86_64/docker-${docker_release}.tgz",
    destination => '/tmp/',
    verbose     => true,
  }->
  exec { 'extract_docker_binaries':
    command => "tar zxvf /tmp/docker-${docker_release}.tgz -C /opt"
  }->
  exec { 'link_docker_binaries':
    command => 'ln -s /opt/docker/docker /usr/local/bin/docker',
  }->
  exec { 'rm_docker_download':
    command => "rm /tmp/docker-${docker_release}.tgz",
  }

}
