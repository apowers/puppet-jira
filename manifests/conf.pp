#
# Configure Jira
#
# BUGS:
# database configuration is hardcoded for postgresql
#
class jira::conf (
  $proxy_name      = undef,
  $config_files    = hash([]),
  $data_path       = $jira::data_path,
  $download_file   = $jira::download_file,
  $install_path    = $jira::install_path,
  $jira_owner      = $jira::owner,
  $jira_group      = $jira::group,
  $download_url    = $jira::download_url,
  $database_pwd    = $jira::database_pwd,
  $database_name   = $jira::database_name,
  $database_user   = $jira::database_user,
  $database_server = $jira::database_server,
) {

  validate_string($database_pwd,$database_name,$database_user)

  ## Resource defaults
  File {
    owner  => $jira_owner,
    group  => $jira_group,
    mode   => '0444',
  }

  create_resources(file,$config_files)

  # Tomcat server configuration file:
  file { "${install_path}/conf/server.xml":
    ensure => present,
    content => template("jira/server.xml.erb"),
  }

  # Database configuration:
  # BUG: currently only works with postgresql
  file { "${data_path}/dbconfig.xml":
    ensure  => present,
    mode    => 0400,
    content => template("jira/dbconfig.xml.erb"),
  }

}
