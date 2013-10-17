#
# Install and configure Jira
#
# Documentation is in README.md
#
class jira (
  $download_file   = undef,
  $database_pwd    = undef,
  $database_name   = 'jira',
  $database_user   = 'jira',
  $database_server = 'localhost',
  $install_path    = '/opt/atlassian/jira',
  $data_path       = '/opt/atlassian/jira-data',
  $jira_owner      = 'jira',
  $jira_group      = 'jira',
  $download_url    = 'http://www.atlassian.com/software/jira/downloads/binary/',
  $service_ensure  = 'running',
  $service_enable  = true,
) {

  validate_string($database_pwd,$database_name,$database_user)

  class { 'jira::package':
    download_file => $download_file,
    install_path  => $install_path,
    data_path     => $data_path,
  } ->
  class { 'jira::conf':
    install_path    => $install_path,
    data_path       => $data_path,
    database_pwd    => $database_pwd,
    database_name   => $database_name,
    database_user   => $database_user,
    database_server => $database_server,
  } ~>
  class { 'jira::service':
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
