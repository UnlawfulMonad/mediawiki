
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

  file { '/usr/bin/install_mediawiki.sh':
    ensure => present,
    source => 'puppet:///modules/mediawiki/install_mediawiki.sh',
    mode   => '0755',
    owner  => root,
    group  => root;
  }

  if $secured {
    $server_url = "https://$server"
  } else {
    $server_url = "http://$server"
  }

  exec { 'install mediawiki':
    require => [
      Class['apache'],
      File['/usr/bin/install_mediawiki.sh'],
    ],
    path    => ['/usr/bin', '/bin'],
    command => "/bin/bash /usr/bin/install_mediawiki.sh \
$version \
admin \
--pass admin \
--server $server_url \
--scriptpath $script_path \
--dbtype postgres \
--dbserver $db_server \
--installdbuser $db_username \
--installdbpass $db_password \
--dbname $db_name \
--dbuser $db_username \
--dbpass $db_password \
--confpath /var/lib/mediawiki \
--lang $language
";
  } ->
  file { '/var/www/html/mediawiki':
    target    => '/var/lib/mediawiki',
    ensure    => link;
  }
}
