#/etc/puppet/modules/build_slaves/manifests/init.pp

class build_slaves (
  $distro_packages  = [],
  $old_users =['eli', 'jlowe', 'rvs', 'tedyu', 'tmary', 'tucu', 'cos', 'evans', 'jfarrell', 'michim', 'shv', 'tgravas', 'todd', 'wang'],
  ) {

  require build_slaves

  class { "build_slaves::install::${::asfosname}::${::asfosrelease}":
  }

  define build_slaves::remove_users ($user = $title) {
    exec { "remove_${user}":
      command => 'userdel -f ${user} && rm -rf /home/${user}',
      onlyif  => 'grep -c ${user} /etc/passwd'
    }
  }
  build_slaves::remove_users { $old_users: }

  package {
    $distro_packages:
      ensure => installed,
  }

  python::pip { 'Flask' :
    pkgname       => 'Flask';
  }

}
