class auditd::audisp::au_remote {
  stdlib::ensure_packages($auditd::params::audisp_package)

  auditd::audisp::plugin { 'au-remote':
    path    => '/sbin/audisp-remote',
    require => Package[$auditd::params::audisp_package],
  }
}
