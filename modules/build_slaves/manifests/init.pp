#/etc/puppet/modules/build_slaves/manifests/init.pp

class build_slaves (
  $distro_packages  = [],
  ) {

  class { "build_slaves::install::${::asfosname}::${asfosname}_${::asfosrelease}":
  }

  package {
    $distro_packages:
      ensure => installed,
  }

  python::pip { 'Flask' :
    pkgname       => 'Flask';
  }

}
