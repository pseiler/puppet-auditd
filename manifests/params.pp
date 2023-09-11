class auditd::params {
  # OS specific variables.
  case $facts['os']['family'] {
    'Suse': {
      $package_name = 'audit'
      $audisp_dir   = '/etc/audisp'
      $disp_qos     = 'lossy'
      $dispatcher   = '/sbin/audispd'

      # Starting with SLES15 SP4 it uses auditd >= 3.0 and has no audisp configuration anymore.
      if versioncmp($facts['os']['release']['full'], '15.4') >= 0 {
        $has_audisp_config = false
      }
      else {
        $has_audisp_config = true
      }
      if versioncmp($facts['os']['release']['major'], '12') >= 0 {
        $audisp_package     = 'audit-audispd-plugins'
        $manage_audit_files = true
        $rules_file         = '/etc/audit/rules.d/puppet.rules'
        $service_restart    = '/bin/systemctl restart auditd'
        $service_stop       = '/bin/systemctl stop auditd'
      }
      else {
        $audisp_package     = 'audispd-plugins'
        $manage_audit_files = false
        $rules_file         = '/etc/audit/audit.rules'
        $service_restart    = '/etc/init.d/auditd restart'
        $service_stop       = '/etc/init.d/auditd stop'
      }
    }
    'RedHat': {
      $package_name       = 'audit'
      $audisp_package     = 'audispd-plugins'
      $manage_audit_files = true

      if versioncmp($facts['os']['release']['major'], '8') >= 0 {
        $has_audisp_config = false
        $audisp_dir        = '/etc/audit'
        $disp_qos          = undef
        $dispatcher        = undef
      } else {
        $has_audisp_config = true
        $audisp_dir        = '/etc/audisp'
        $disp_qos          = 'lossy'
        $dispatcher        = '/sbin/audispd'
      }

      if $facts['os']['name'] != 'Amazon' and versioncmp($facts['os']['release']['major'], '7') >= 0 {
        $rules_file      = '/etc/audit/rules.d/puppet.rules'
        $service_restart = '/usr/libexec/initscripts/legacy-actions/auditd/restart'
        $service_stop    = '/usr/libexec/initscripts/legacy-actions/auditd/stop'
      } else {
        $rules_file      = '/etc/audit/audit.rules'
        $service_restart = '/etc/init.d/auditd restart'
        $service_stop    = '/etc/init.d/auditd stop'
      }
    }
    default: {
      fail("${facts['os']['family']} is not supported by auditd")
    }
  }

  # Main config file variables
  $log_file                = '/var/log/audit/audit.log'
  $log_format              = 'RAW'
  $log_group               = 'root'
  $write_logs              = undef
  $priority_boost          = 4
  $flush                   = 'incremental_async'
  $freq                    = 20
  $num_logs                = 5
  $name_format             = 'none'
  $admin                   = $facts['networking']['hostname']
  $max_log_file            = 6
  $max_log_file_action     = 'rotate'
  $space_left              = 75
  $space_left_action       = 'syslog'
  $action_mail_acct        = 'root@example.com'
  $admin_space_left        = 50
  $admin_space_left_action = 'suspend'
  $disk_full_action        = 'suspend'
  $disk_error_action       = 'suspend'
  $tcp_listen_port         = undef
  $tcp_listen_queue        = 5
  $tcp_max_per_addr        = 1
  $tcp_client_ports        = undef
  $tcp_client_max_idle     = '0'
  $enable_krb5             = 'no'
  $krb5_principal          = 'auditd'
  $krb5_key_file           = undef

  # Rules Header variables
  $buffer_size      = '8192'
  $continue_loading = false

  # Audisp main config variables
  $audisp_q_depth          = 80
  $audisp_overflow_action  = 'syslog'
  $audisp_priority_boost   = 4
  $audisp_max_restarts     = 10
  $audisp_name_format      = 'none'
  $audisp_name             = undef

  # Give the option of managing the service.
  $manage_service         = true
  $service_ensure         = 'running'
  $service_enable         = true

  # these files are ignored and won't get purged by the module
  $ignored_files_on_purge = []
}
