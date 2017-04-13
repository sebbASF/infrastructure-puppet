#/etc/puppet/modules/build_slaves/manifests/init.pp

class build_slaves (
  $distro_packages  = [],
  ) {

  class { "build_slaves::install::${::asfosname}::${::asfosrelease}":
  }

	# this is a stupid hack to fix a stupid problem
	# this hard coded list of users was added to the Y! image templates
	# so this guarantees these users are not on the system
	# the onlyif is because if one user is on, then they all probably are
	# this will error in puppet (but run correctly) if a non-empty subset of
	#     users is not there
	exec { "remove-old-accounts":
		command => 'for i in eli jlowe rvs tedyu tmary tucu cos evans jfarrell michim shv tgravas todd wang; do /bin/grep -c $i /etc/passwd && /usr/sbin/userdel -f $i && /bin/rm -rf /home/$i; done',
		provider => shell,
		onlyif => '/bin/grep -c eli /etc/passwd',
	}

  package {
    $distro_packages:
      ensure => installed,
  }

  python::pip { 'Flask' :
    pkgname       => 'Flask';
  }

}
