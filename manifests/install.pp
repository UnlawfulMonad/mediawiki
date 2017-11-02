
class mediawiki::install (
  $ensure = 'present',
  ) inherits mediawiki::params {

  class { 'apache':
    default_vhost   => false,
    purge_vhost_dir => false,
    mpm_module      => 'prefork';
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
      ensure => $ensure;
    }
  }

  exec { 'enable mbstring module':
    command  => 'phpenmod mbstring',
    provider => 'shell',
    require  => Package['php-mbstring'];
  }

  exec { 'enable xml module':
    command  => 'phpenmod xml',
    provider => 'shell',
    require  => Package['php-xml'];
  }

  file { '/usr/local/bin/install_mediawiki.sh':
    source => 'puppet:///modules/mediawiki/install_mediawiki.sh',
    mode   => '0755',
    owner  => root,
    group  => root,
  } ->
  exec { 'install mediawiki':
    require  => Class['apache'],
    command  => "/bin/bash /usr/local/bin/install_mediawiki.sh $version";
  } ~>
  file { '/var/www/html/mediawiki':
    target    => '/var/lib/mediawiki',
    ensure    => link;
  }
}
