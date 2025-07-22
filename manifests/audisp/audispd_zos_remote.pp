class auditd::audisp::audispd_zos_remote {
  stdlib::ensure_packages($auditd::params::audisp_package)

  auditd::audisp::plugin { 'audispd-zos-remote':
    path    => '/sbin/audispd-zos-remote',
    args    => '/etc/audisp/zos-remote.conf',
    require => Package[$auditd::params::audisp_package],
  }
}
