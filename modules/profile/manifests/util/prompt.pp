# == Class: ::profile::util::prompt
#
# Prefix the shell prompt with the name of the container
#
class profile::util::prompt {
  file { '/etc/debian_chroot':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => $::node,
  }
}
