
class mediawiki::params (
  Boolean $manage_install = true,
  Boolean $manage_config = true,

  String $basedir = '/var/lib/mediawiki',

  String $version = '1.29.1',
  String $db_type = 'postgres',
  String $db_server,
  String $db_name,
  String $db_username,
  String $db_password,
  Integer $db_port = 5432,
  String $db_schema = 'mediawiki',
  String $site_name,
  String $script_path = '/mediawiki',
  String $server = $facts['certname'],

  String $emergency_contact = '',
  String $password_sender = '',

  String $secret_key,

  Boolean $email_authentication = false,

  String $shell_locale = 'en_US.utf8',

  # Relative to $IP
  Optional[String] $cache_directory = undef,

  String $language = 'en',

  Boolean $secured = false,
  Boolean $enable_email = false,
  Boolean $enable_user_email = false,

  Boolean $enable_image_uploads = true,
  Boolean $enable_imagemagick = true,
  String $imagemagick_convert_command = '/usr/bin/convert',

  Boolean $enable_instant_commons = false,
  Boolean $enable_telemetry = false,
  Boolean $allow_account_creation = true,
  Boolean $allow_edit = true,

  String $logo_url = "",

  Array[String] $file_extensions = [],

  Array[String] $skins = ['CologneBlue', 'Modern', 'MonoBook', 'Vector'],
  String $default_skin = 'vector',
  ){
}
