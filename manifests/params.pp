class auditd::params {
  # OS specific variables.
  case $facts['os']['family'] {
    'Suse': {
      $package_name              = 'audit'
      $audisp_package            = 'audit-audispd-plugins'
      $manage_audit_files        = true
      $rules_file                = '/etc/audit/rules.d/puppet.rules'

      # Starting with SLES15 SP4 it uses auditd >= 3.0 and has no audisp configuration anymore.
      if versioncmp($facts['os']['release']['full'], '15.4') >= 0 {
        $has_audisp_config = false
        $audisp_dir                = '/etc/audit'
        $disp_qos                  = undef
        $dispatcher                = undef
        $auditd_audisp_syslog_path = '/sbin/audisp-syslog'
        $auditd_audisp_syslog_type = 'always'
      }
      else {
        $has_audisp_config = true
        $audisp_dir                = '/etc/audisp'
        $disp_qos                  = 'lossy'
        $dispatcher                = '/sbin/audispd'
        $auditd_audisp_syslog_path = 'builtin_syslog'
        $auditd_audisp_syslog_type = 'builtin'
      }
    }
    'RedHat': {
      $package_name       = 'audit'
      $audisp_package     = 'audispd-plugins'
      $manage_audit_files = true


      if versioncmp($facts['os']['release']['major'], '8') >= 0 {
        $has_audisp_config        = false
        $audisp_dir               = '/etc/audit'
        $disp_qos                 = undef
        $dispatcher               = undef
        $auditd_audisp_syslog_path = '/sbin/audisp-syslog'
        $auditd_audisp_syslog_type = 'always'
      } else {
        $has_audisp_config        = true
        $audisp_dir               = '/etc/audisp'
        $disp_qos                 = 'lossy'
        $dispatcher               = '/sbin/audispd'
        $auditd_audisp_syslog_path = 'builtin_syslog'
        $auditd_audisp_syslog_type = 'builtin'
      }

      if $facts['os']['name'] != 'Amazon' and versioncmp($facts['os']['release']['major'], '7') >= 0 {
        $rules_file      = '/etc/audit/rules.d/puppet.rules'
      } else {
        $rules_file      = '/etc/audit/audit.rules'
      }
    }
    default: {
      fail("OS family \"${facts['os']['family']}\" is not supported by auditd")
    }
  }
}
