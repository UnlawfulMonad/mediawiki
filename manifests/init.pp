
class mediawiki inherits mediawiki::params {

  if $manage_install {
    include mediawiki::install
  }

  if $manage_configuration {
    include mediawiki::config
  }
}
