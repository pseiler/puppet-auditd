define auditd::audisp::plugin (
  $active     = true,
  $direction  = 'out',
  $path       = undef,
  $type       = 'always',
  $args       = undef,
  $format     = 'string',
  $audisp_dir = $auditd::params::audisp_dir
) {
  assert_type(Boolean,$active)
  if $direction !~ '^(out|in)$' {
    fail("${direction} is not supported for 'direction'. Allowed values are 'out' and 'in'.")
  }
  assert_type(String, $path)
  if $type !~ '^(builtin|always)$' {
    fail("${type} is not supported for 'type'. Allowed values are 'builtin' and 'always'.")
  }
  if $args {
    assert_type(String,$args)
  }
  if $format !~ '^(binary|string)$' {
    fail("${format} is not supported for 'format'. Allowed values are 'binary' and 'string'.")
  }
  if $active == true {
    $real_active = 'yes'
  }
  elsif $active == false {
    $real_active = 'no'
  }

  file { "${audisp_dir}/plugins.d/${name}.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/audisp.plugin.erb"),
    notify  => Service['auditd'],
  }
}
