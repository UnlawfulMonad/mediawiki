
class mediawiki::install (
  $ensure = 'present',
  ) inherits mediawiki::params {

  class { 'apache':
    default_vhost   => false,
    purge_vhost_dir => false,
  }

  $packages = [
    'php',
    'php-pgsql',
    'libapache2-mod-php',
    'php-xml',
    'php-mbstring'
  ]

  package { $packages:
    require => Class['apache'],
    ensure  => $ensure,
  }

  if $enable_imagemagick {
    package { 'imagemagick':
      ensure => $ensure,
    }
  }

  exec { 'enable mbstring module':
    command => 'phpenmod mbstring',
    provide => 'shell',
    require => Package['php-mbstring'],
  }

  exec { 'enable xml module':
    command => 'phpenmod xml',
    provide => 'shell',
    require => Package['php-xml'],
  }

  file { '/usr/local/bin/install_mediawiki.sh':
    source => 'puppet:///modules/mediawiki/install_mediawiki.sh',
    mode   => '0755',
    owner  => root,
    group  => root;
  }

  exec { 'install mediawiki':
    require  => [
      File['/usr/local/bin/install_mediawiki.sh'],
      Class['apache']
    ],
    command  => "/usr/local/bin/install_mediawiki.sh $version";
  }

  file { '/var/www/html/mediawiki':
    subscribe => Exec['install mediawiki'],
    target    => '/var/lib/mediawiki',
    ensure    => link;
  }
}
