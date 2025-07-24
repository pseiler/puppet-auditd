# == Class: auditd
#
# Full description of class auditd here.
#
# === Parameters
#
# Document parameters here.
#
# [*package_name*]
#   The package name for auditd.
#
# [*manage_audit_files*]
#   If true then /etc/audit/rules.d/ will be managed by this module.
#   This means any rules not created using this module's defined type
#   will be removed.
#
# [*ignored_files_on_purge*]
#   Array containing files that should not be purged when manage_audit_files is set to true.
#   See puppet's file ressource and ignore parameter for possible globbing options.
#   When manage_audit_files is false, this parameter has no meaning.
#
# [*rules_file*]
#   The file that Audit rules should be added to.
#
# [*log_file*]
#   This keyword specifies the full path name to the log file where audit
#   records will be stored. It must be a regular file.
#
# [*log_format*]
#   The log format describes how the information should be stored on disk.
#   There are 3 options: RAW, ENRICHED and NOLOG. If set to RAW , the audit records
#   will be stored in a format exactly as the kernel sends it. If this option is
#   is set to ENRICHED it will resolve all uid, gid, syscall, architecture, and
#   socket address address information before writing the event to disk. This aids
#   in making sense of eveents created on one system but reported/analizedon another
#   system. If this option is set to NOLOG then all audit information is discarded
#   instead of writing to disk. This mode does not affect data sent to the audit
#   event dispatcher.
#
# [*log_group*]
#   This keyword specifies the group that is applied to the log file's
#   permissions. The default is root. The group name can be either numeric
#   or spelled out.
#
# [*write_logs*]
#   This yes/no keyword determines whether or not to write logs to the disk.
#   There are two options: yes and no. It is meant to replace the usage of
#   log_format = NOLOG. This will default to undef since it is only available
#   in version >= 2.5.2.
#
# [*priority_boost*]
#   This is a non-negative number that tells the audit damon how much of
#   a priority boost it should take. The default is 3. No change is 0.
#
# [*flush*]
#   Valid values are none, incremental, incremental_async, data, and sync. If
#   set to none, no special effort is made to flush the audit records to
#   disk. If set to incremental, Then the freq parameter is used to determine
#   how often an explicit flush to disk is issued. The incremental_async
#   parameter is very much like incremental except the flushing is done
#   asynchronously for higher performance. The data parameter tells the audit
#   daemon to keep the data portion of the disk file sync'd at all times. The
#   sync option tells the audit daemon to keep both the data and meta-data
#   fully sync'd with every write to disk. The default value is
#   incremental_async.
#
# [*freq*]
#   This is a non-negative number that tells the audit damon how many records
#   to write before issuing an explicit flush to disk command. this value is
#   only valid when the flush keyword is set to incremental.
#
# [*num_logs*]
#   This keyword specifies the number of log files to keep if rotate is given
#   as the max_log_file_action. If the number is < 2, logs are not rotated.
#   This number must be 99 or less. The default is 0 - which means no
#   rotation. As you increase the number of log files being rotated, you may
#   need to adjust the kernel backlog setting upwards since it takes more time
#   to rotate the files.
#
# [*disp_qos*]
#   This option controls whether you want blocking/lossless or
#   non-blocking/lossy communication between the audit daemon and the
#   dispatcher. There is a 128k buffer between the audit daemon and
#   dispatcher. This is good enogh for most uses. If lossy is chosen, incoming
#   events going to the dispatcher are discarded when this queue is full.
#   (Events are still written to disk if log_format is not nolog.) Otherwise
#   the auditd daemon will wait for the queue to have an empty spot before
#   logging to disk. The risk is that while the daemon is waiting for network
#   IO, an event is not being recorded to disk. Valid values are: lossy and
#   lossless.
#
# [*dispatcher*]
#   The dispatcher is a program that is started by the audit daemon when it
#   starts up. It will pass a copy of all audit events to that application's
#   stdin. Make sure you trust the application that you add to this line since
#   it runs with root privileges.
#
# [*name_format*]
#   This option controls how computer node names are inserted into the audit
#   event stream. It has the following choices: none, hostname, fqd, numeric,
#   and user. None means that no computer name is inserted into the audit
#   event. hostname is the name returned by the gethostname syscall. The fqd
#   means that it takes the hostname and resolves it with dns for a fully
#   qualified domain name of that machine. Numeric is similar to fqd except
#   it resolves the IP address of the machine. User is an admin defined string
#   from the name option.
#
# [*admin*]
#   This is the admin defined string that identifies the machine if user is
#   given as the name_format option.
#
# [*max_log_file*]
#   This keyword specifies the maximum file size in megabytes. When this limit
#   is reached, it will trigger a configurable action. The value given must
#   be numeric.
#
# [*max_log_file_action*]
#   This parameter tells the system what action to take when the system has
#   detected that the max file size limit has been reached. Valid values are
#   ignore, syslog, suspend, rotate and keep_logs. If set to ignore, the audit
#   daemon does nothing. syslog means that it will issue a warning to syslog.
#   suspend will cause the audit daemon to stop writing records to the disk.
#   The daemon will still be alive. The rotate option will cause the audit
#   daemon to rotate the logs. It should be noted that logs with higher
#   numbers are older than logs with lower numbers. This is the same convention
#   used by the logrotate utility. The keep_logs option is similar to rotate
#   except it does not use the num_logs setting. This prevents audit logs from
#   being overwritten.
#
# [*space_left*]
#   This is a numeric value in megabytes that tells the audit daemon when to
#   perform a configurable action because the system is starting to run low
#   on disk space.
#
# [*space_left_action*]
#   This parameter tells the system what action to take when the system has
#   detected that it is starting to get low on disk space. Valid values are
#   ignore, syslog, email, suspend, single, and halt. If set to ignore, the
#   audit daemon does nothing. syslog means that it will issue a warning to
#   syslog. Email means that it will send a warning to the email account
#   specified in action_mail_acct as well as sending the message to syslog.
#   suspend will cause the audit daemon to stop writing records to the disk.
#   The daemon will still be alive. The single option will cause the audit
#   daemon to put the computer system in single user mode. halt option will
#   cause the audit daemon to shutdown the computer system.
#
# [*verify_email*]
#   This parameter determines if the email address given in action_mail_acct
#   is checked to see if the domain name can be resolved. This option must
#   be given before action_mail_acct or the default value of true will be
#   used.
#
# [*action_mail_acct*]
#   This option should contain a valid email address or alias. The default
#   address is root. If the email address is not local to the machine, you
#   must make sure you have email properly configured on your machine and
#   network. Also, this option requires that /usr/lib/sendmail exists on the
#   machine.
#
# [*admin_space_left*]
#   This is a numeric value in megabytes that tells the audit daemon when to
#   perform a configurable action because the system is running low on disk
#   space. This should be considered the last chance to do something before
#   running out of disk space. The numeric value for this parameter should be
#   lower than the number for space_left.
#
# [*admin_space_left_action*]
#   This parameter tells the system what action to take when the system has
#   detected that it is low on disk space. Valid values are ignore, syslog,
#   email, suspend, single, and halt. If set to ignore, the audit daemon does
#   nothing. Syslog means that it will issue a warning to syslog. Email means
#   that it will send a warning to the email account specified in
#   action_mail_acct as well as sending the message to syslog. Suspend will
#   cause the audit daemon to stop writing records to the disk. The daemon will
#   still be alive. The single option will cause the audit daemon to put the
#   computer system in single user mode. halt option will cause the audit
#   daemon to shutdown the computer system.
#
# [*disk_full_action*]
#   This parameter tells the system what action to take when the system has
#   detected that the partition to which log files are written has become
#   full. Valid values are ignore, syslog, suspend, single, and halt. If set
#   to ignore, the audit daemon does nothing. Syslog means that it will issue
#   a warning to syslog. Suspend will cause the audit daemon to stop writing
#   records to the disk. The daemon will still be alive. The single option
#   will cause the audit daemon to put the computer system in single user
#   mode. halt option will cause the audit daemon to shutdown the computer
#   system.
#
# [*disk_error_action*]
#   This parameter tells the system what action to take whenever there is an
#   error detected when writing audit events to disk or rotating logs. Valid
#   values are ignore, syslog, suspend, single, and halt. If set to ignore,
#   the audit daemon does nothing. Syslog means that it will issue a warning
#   to syslog. Suspend will cause the audit daemon to stop writing records to
#   the disk. The daemon will still be alive. The single option will cause the
#   audit daemon to put the computer system in single user mode. halt option
#   will cause the audit daemon to shutdown the computer system.
#
# [*tcp_listen_port*]
#   This is a numeric value in the range 1..65535 which, if specified, causes
#   auditd to listen on the corresponding TCP port for audit records from
#   remote systems. The audit daemon may be linked with tcp_wrappers. You may
#   want to controll access with an entry in the hosts.allow and deny files.
#
# [*tcp_listen_queue*]
#   This is a numeric value which indicates how many pending (requested but
#   unaccepted) connections are allowed. The default is 5. Setting this too
#   small may cause connections to be rejected if too many hosts start up at
#   exactly the same time, such as after a power failure.
#
# [*tcp_max_per_addr*]
#   This is a numeric value which indicates how many concurrent connections
#   from one IP address is allowed. The default is 1 and the maximum is 16.
#   Setting this too large may allow for a Denial of Service attack on the
#   logging server. The default should be adequate in most cases unless a
#   custom written recovery script runs to forward unsent events. In this
#   case you would increase the number only large enough to let it in too.
#
# [*tcp_client_ports*]
#   This parameter may be a single numeric value or two values separated by a
#   dash (no spaces allowed). It indicates which client ports are allowed for
#   incoming connections. If not specified, any port is allowed. Allowed
#   values are 1..65535. For example, to require the client use a privileged
#   port, specify 1-1023 for this parameter. You will also need to set the
#   local_port option in the audisp-remote.conf file. Making sure that clients
#   send from a privileged port is a security feature to prevent log injection
#   attacks by untrusted users.
#
# [*tcp_client_max_idle*]
#   This parameter indicates the number of seconds that a client may be idle
#   (i.e. no data from them at all) before auditd complains. This is used to
#   close inactive connections if the client machine has a problem where it
#   cannot shutdown the connection cleanly. Note that this is a global setting,
#   and must be higher than any individual client heartbeat_timeout setting,
#   preferably by a factor of two. The default is zero, which disables this
#   check.
#
# [*enable_krb5*]
#   If set to "yes", Kerberos 5 will be used for authentication and encryption.
#
# [*krb5_principal*]
#   This is the principal for this server. The default is "auditd". Given this
#   default, the server will look for a key named like
#   auditd/hostname@EXAMPLE.COM stored in /etc/audit/audit.key to authenticate
#   itself, where hostname is the canonical name for the server's host, as
#   returned by a DNS lookup of its IP address.
#
# [*krb5_key_file*]
#   Location of the key for this client's principal. Note that the key file
#   must be owned by root and mode 0400.
#
# [*rules_file*]
#   Location of the Audit rules file.
#
# [*manage_audit_files*]
#   On systems with 'rules.d' directory whether or not to manage that directory
#   removing rules not managed by Puppet.
#
# [*buffer_size*]
#   Sets the buffer size used by Auditd.
#
# [*audisp_q_depth*]
#   This is a numeric value that tells how big to make the internal queue of
#   the audit event dispatcher. A bigger queue lets it handle a flood of
#   events better, but could hold events that are not processed when the daemon
#   is terminated. If you get messages in syslog about events getting dropped,
#   increase this value.
#
# [*audisp_overflow_action*]
#   This option determines how the daemon should react to overflowing its
#   internal queue. When this happens, it means that more events are being
#   received than it can get rid of. This error means that it is going to lose
#   the current event its trying to dispatch. It has the following choices:
#   ignore, syslog, suspend, single, and halt. If set to ignore, the audisp
#   daemon does nothing. syslog means that it will issue a warning to syslog.
#   suspend will cause the audisp daemon to stop processing events. The daemon
#   will still be alive. The single option will cause the audisp daemon to put
#   the computer system in single user mode. halt option will cause the audisp
#   daemon to shutdown the computer system.
#
# [*audisp_priority_boost*]
#   This is a non-negative number that tells the audit event dispatcher how
#   much of a priority boost it should take. This boost is in addition to the
#   boost provided from the audit daemon. The default is 4. No change is 0.
#
# [*audisp_max_restarts*]
#   This is a non-negative number that tells the audit event dispatcher how
#   many times it can try to restart a crashed plugin.
#
# [*audisp_max_restarts*]
#   This option controls how computer node names are inserted into the audit
#   event stream. It has the following choices: none, hostname, fqd, numeric,
#   and user. None means that no computer name is inserted into the audit
#   event. hostname is the name returned by the gethostname syscall. The fqd
#   means that it takes the hostname and resolves it with dns for a fully
#   qualified domain name of that machine. Numeric is similar to fqd except it
#   resolves the IP address of the machine. User is an admin defined string
#   from the name option.
#
# [*audisp_name*]
#   This is the admin defined string that identifies the machine if user is
#   given as the name_format option.
#
# [*manage_service*]
#   Whether or not the auditd service should be managed. This should only
#   be set to false if you use another module to manage auditd service
#   such as an selinux module.
#
# [*service_ensure*]
#   The status the auditd daemon should be in.
#
# [*service_enable*]
#   Whether or not to start the auditd service on boot.
#
# [*rules*]
#   Hash of auditd rules to be applied using the audit::rule defined type.
#
# [*continue_loading*]
#   Wether or not parsing the rules should stop when an error occurs.
#
# [*ignore_errors*]
#   When  given by itself, ignore errors when reading rules from a file. This causes auditctl to always return a success exit code. If passed as an argument to -s then it gives an interpretation of the numbers to human readable
#              words if possible.
#
# [*generate_rules*]
#   Generate rules from files.
#
# === Examples
#
#  class { 'auditd':
#    log_file => '/var/log/audit.log',
#  }
#
# === Authors
#
# Danny Roberts <danny@thefallenphoenix.net>
#
# === Copyright
#
# Copyright 2015 Danny Roberts
#
class auditd (

  String $package_name                                                               = $auditd::params::package_name,

  # Config file variables
  String $log_file                                                                   = '/var/log/audit/audit.log',
  Enum['NOLOG','RAW','ENRICHED'] $log_format                                         = 'RAW',
  String $log_group                                                                  = 'root',
  Optional[Boolean] $write_logs                                                      = undef,
  Integer[0] $priority_boost                                                         = 4,
  Enum['none','incremental','incremental_async','data','sync'] $flush                = 'incremental_async',
  Integer[0] $freq                                                                   = 20,
  Integer[1] $num_logs                                                               = 5,
  Optional[Enum['lossy','lossless']] $disp_qos                                       = $auditd::params::disp_qos,
  Optional[String] $dispatcher                                                       = $auditd::params::dispatcher,
  Enum['none','hostname','fqd','numeric','user'] $name_format                        = 'none',
  String $admin                                                                      = $facts['networking']['hostname'],
  Integer $max_log_file                                                              = 6,
  Enum['ignore','syslog','suspend','rotate','keep_logs'] $max_log_file_action        = 'rotate',
  Integer $space_left                                                                = 75,
  Enum['ignore','syslog','email','suspend','single','halt'] $space_left_action       = 'syslog',
  Optional[Boolean] $verify_email                                                    = undef,
  String $action_mail_acct                                                           = 'root@example.com',
  Integer $admin_space_left                                                          = 50,
  String[1] $admin_space_left_action                                                 = 'suspend',
  Enum['ignore','syslog','suspend','single','halt'] $disk_full_action                = 'suspend',
  Enum['ignore','syslog','suspend','single','halt'] $disk_error_action               = 'suspend',
  Optional[Integer[1,65535]] $tcp_listen_port                                        = undef,
  Integer $tcp_listen_queue                                                          = 5,
  Integer[1,16] $tcp_max_per_addr                                                    = 1,
  # this line is awful. It's a optional parameter which can be an Integer or an Array that contains two Integers at max.
  # also these Integers (with or without the parent array) also have a min and a max value.
  Optional[Variant[Integer[1,65535],Array[Integer[1,65535],1,2]]] $tcp_client_ports  = undef,
  Integer[0] $tcp_client_max_idle                                                    = 0,
  Boolean $enable_krb5                                                               = false,
  String $krb5_principal                                                             = 'auditd',
  Optional[String] $krb5_key_file                                                    = undef,
  Boolean $continue_loading                                                          = false,
  Boolean $ignore_errors                                                             = false,
  Boolean $generate_rules                                                            = false,

  # Variables for Audit files
  String $rules_file                    = $auditd::params::rules_file,
  Boolean $manage_audit_files           = $auditd::params::manage_audit_files,
  Array[String] $ignored_files_on_purge = [],
  Integer $buffer_size                  = 8192,

  # Audisp main config variables
  Integer[0] $audisp_q_depth                                                = 80,
  Enum['ignore','syslog','suspend','single','halt'] $audisp_overflow_action = 'syslog',
  Integer[0] $audisp_priority_boost                                         = 4,
  Integer[0] $audisp_max_restarts                                           = 10,
  Enum['none','hostname','fqd','numeric','user'] $audisp_name_format        = 'none',
  Optional[String] $audisp_name                                             = undef,
  Boolean $has_audisp_config                                                = $auditd::params::has_audisp_config,

  # Service management variables
  Boolean $manage_service                                    = true,
  Variant[Boolean,Enum['running','stopped']] $service_ensure = 'running',
  Boolean $service_enable                                    = true,
  String $service_name                                       = 'auditd',
  Optional[String] $service_provider                         = undef,

  # Optionally define rules through main class
  $rules                   = {},

) inherits auditd::params {
  # Validate all special variables

  assert_type(Stdlib::Absolutepath, $log_file)

  if $disp_qos != undef {
    assert_type(Stdlib::Absolutepath, $dispatcher)
  }
  # check if email address is valid
  if $action_mail_acct !~ /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/ {
    fail("Parameter error: E-Mail address \"${action_mail_acct}\" is not valid.")
  }
  if $tcp_client_ports != undef {
    assert_type(Stdlib::Absolutepath, $krb5_key_file)
  }

  assert_type(Stdlib::Absolutepath, $rules_file)

  # Install package
  package { $package_name:
    ensure => 'present',
    alias  => 'auditd',
    before => [
      File['/etc/audit/auditd.conf'],
      Concat[$rules_file],
    ],
  }

  # Configure required config files
  file { '/etc/audit/auditd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('auditd/auditd.conf.erb'),
  }
  if $manage_audit_files {
    file { '/etc/audit/rules.d':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
      recurse => true,
      purge   => true,
      ignore  => $ignored_files_on_purge,
      require => Package[$package_name],
    }
  }
  concat { $rules_file:
    ensure         => 'present',
    owner          => 'root',
    group          => 'root',
    mode           => '0640',
    ensure_newline => true,
    warn           => true,
  }
  concat::fragment { 'auditd_rules_begin':
    target  => $rules_file,
    content => template('auditd/audit.rules.begin.fragment.erb'),
    order   => 0,
  }
  if($has_audisp_config) {
    file { '/etc/audisp/audispd.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => template('auditd/audispd.conf.erb'),
      require => Package[$package_name],
    }
    if ($manage_service) {
      File['/etc/audisp/audispd.conf'] ~> Service['auditd']
    }
  }

  # If a hash of rules is supplied with class then call auditd::rules defined type to apply them
  $rules.each |$key,$opts| {
    auditd::rule { $key:
      * => pick($opts, {}),
    }
  }

  # Manage the service
  if $manage_service {
    if $facts['os']['family'] =~ 'RedHat' {
      $redhat_args = {
        'restart' => 'service auditd restart',
        'start'   => 'service auditd start',
        'status'  => 'service auditd status',
        'stop'    => 'service auditd stop'}
    }
    else {
      $redhat_args = {}
    }
    service { $service_name:
      ensure    => $service_ensure,
      enable    => $service_enable,
      hasstatus => true,
      *         => $redhat_args,
    }
  }
  if $generate_rules {
      exec { 'generate_rules':
        command     => 'augenrules --load',
        path        => ['/sbin','/bin','/usr/sbin','/usr/bin'],
        refreshonly => true,
        subscribe   => [
          Concat[$rules_file],
        ],
      }
  }
}
