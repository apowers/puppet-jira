#
# Install Jira
#
class jira::package (
  $data_path      = $jira::data_path,
  $download_file  = $jira::download_file,
  $install_path   = $jira::install_path,
  $jira_owner     = $jira::owner,
  $jira_group     = $jira::group,
  $download_url   = $jira::download_url,
) {

  validate_string($download_file)

  ## Resource defaults
  File {
    owner  => $jira_owner,
    group  => $jira_group,
    mode   => '0644',
  }

  Exec {
    path      => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    cwd       => $install_path,
    user      => $jira_owner,
    group     => $jira_group,
  }

  ensure_resource(package,'wget',{ensure=>'installed'})

  file { '/tmp/jira.response.varfile':
    ensure  => 'file',
    content => template('jira/jira.response.varfile.erb'),
  }

  if $data_path {
    file { $data_path: ensure => directory }
  }

  ## Installation directory
  file { $install_path:
    ensure  => directory,
  }
  -> exec { 'download-atlassian-jira-pkg':
    command => "wget -nc ${download_url}/${download_file}",
    creates => "${install_path}/${download_file}",
    require => Package['wget'],
  }
  -> exec { 'install-atlassian-jira-pkg':
    command => "/bin/sh ${install_path}/${download_file} -q -varfile /tmp/jira.response.varfile",
    creates => "${install_path}/install.reg",
    require => File['/tmp/jira.response.varfile']
  }

}
