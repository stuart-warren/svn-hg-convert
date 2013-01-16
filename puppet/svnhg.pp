# Class: svnhg
#
#
class svnhg {
	# resources

	$packages = [ 	'subversion-tools',
					'mercurial-server',
					'apache2', ]

	exec { 'apt-update':
	    command     => '/usr/bin/apt-get update',
	}

	package { $packages : 
		ensure   => latest,
		require  => Exec['apt-update'],
	}

	user { 'vagrant':
		groups     => 'hg',
		membership => 'minimum',
		require    => Package['mercurial-server'],
	}

	file { '/etc/mercurial-server/keys/root/vagrant.pub':
		ensure => link,
		target => '/vagrant/files/vagrant.pub',
		require => Package['mercurial-server'],
	}

	
}

class {svnhg: }