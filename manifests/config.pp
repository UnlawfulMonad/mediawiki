
class mediawiki::config inherits mediawiki::params {
  include mediawiki::params

  file_line { 'php memory_limit':
    ensure => 'present',
    path   => '/etc/php/7.0/apache2/php.ini',
    match  => '^memory_limit',
    line   => 'memory_limit = 128M';
  }

  file_line { 'php upload_max_filesize':
    ensure => 'present',
    path   => '/etc/php/7.0/apache2/php.ini',
    match  => '^upload_max_filesize',
    line   => 'unload_max_filesize = 64M';
  }

  file { '/var/lib/mediawiki/LocalSettings.php':
    mode    => '0600',
    owner   => 'www-data',
    group   => 'www-data',
    content => epp('mediawiki/LocalSettings.php.epp');
  }

  if defined(Class['mediawiki::install']) {
    Class['mediawiki::install'] -> File['/var/lib/mediawiki/LocalSettings.php']
  }
}
