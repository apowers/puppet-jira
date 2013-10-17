#
# Manage Jira Service
#
class jira::service (
  $ensure       = $jira::service_ensure,
  $enable       = $jira::service_enable,
  $install_path = $jira::install_path,
) {

  if $enable {
    exec { 'install-jira-init-script':
      command => "${install_path}/bin/install_linux_service.sh",
      creates => "/etc/init.d/jira",
      user    => 'root',
      require => Exec['install-atlassian-jira-pkg'],
      before  => Service['jira'],
    }
  }

  service { 'jira':
    ensure    => $ensure,
    enable    => $enable,
    hasstatus => false,
  }

}
