
class mediawiki inherits mediawiki::params {

  if $manage_install {
    include mediawiki::install
  }

  if $manage_config {
    include mediawiki::config
  }

  Class['mediawiki::install'] -> Class['mediawiki::config']
}
