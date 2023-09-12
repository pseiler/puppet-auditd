function auditd::bool2yesno(Boolean $arg) >> String {
  case $arg {
    false, undef, /(?i:false)/ : { 'no' }
    true, /(?i:true)/          : { 'yes' }
    default                    : { $arg }
  }
}
