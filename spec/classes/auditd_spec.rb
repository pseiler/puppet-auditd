# frozen_string_literal: true

require 'spec_helper'

describe 'auditd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) {
        os_facts.merge(
          'networking' => {
            'hostname' => 'testserver.example.com',
          },
        )
      }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('auditd::params') }
      it { is_expected.to contain_file('/etc/audit/auditd.conf') }
      it { is_expected.to contain_package('auditd') }
      it { is_expected.to contain_service('auditd') }
      it { is_expected.to contain_file('/etc/audit/rules.d')
        .with_ensure('directory')
        .with_recurse(true)
        .with_mode('0750')
        .with_require('Package[audit]')
      }
    end
  end
  context "Check if 'manage_service = false' is acting correctly" do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'AlmaLinux',
          'release' => {
            'major' => '7',
          }
        }
      }
    end
    let(:params) do
      {
        'manage_service' => false,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.not_to contain_service('auditd') }
    it { is_expected.not_to contain_exec('reload_auditd') }
  end

  context "Check if 'manage_service = true' is acting correctly" do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'AlmaLinux',
          'release' => {
            'major' => '8',
          }
        }
      }
    end
    let(:params) do
      {
        'manage_service' => true,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_service('auditd') }
    it { is_expected.to contain_exec('reload_auditd')
      .with_command('/sbin/service auditd reload')
      .with_subscribe('[File[/etc/audit/auditd.conf]{:path=>"/etc/audit/auditd.conf"}, Concat[/etc/audit/rules.d/puppet.rules]{:name=>"/etc/audit/rules.d/puppet.rules"}]')
    }
  end

  context "Check if 'service_provider = systemd' is acting correctly" do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'AlmaLinux',
          'release' => {
            'major' => '8',
          }
        }
      }
    end
    let(:params) do
      {
        'manage_service'   => true,
        'service_provider' => 'systemd',
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_service('auditd') }
    it { is_expected.to contain_exec('reload_auditd')
      .with_command('systemctl reload auditd')
      .with_subscribe('[File[/etc/audit/auditd.conf]{:path=>"/etc/audit/auditd.conf"}, Concat[/etc/audit/rules.d/puppet.rules]{:name=>"/etc/audit/rules.d/puppet.rules"}]')
    }
  end

  context 'Check if enable_service is acting correctly' do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'AlmaLinux',
          'release' => {
            'major' => '7',
          }
        }
      }
    end
    let(:params) do
      {
        'service_enable' => false,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_service('auditd').with_enable(false) }
  end

  context 'Check if audisp is absent on RHEL >= 8' do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'RedHat',
          'release' => {
            'major' => '8',
          }
        }
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('auditd').with('has_audisp_config' => false) }
    it { is_expected.not_to contain_file('/etc/audisp/audispd.conf') }
  end

  context 'Check if audisp is present on RHEL < 8' do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'RedHat',
          'release' => {
            'major' => '7',
          }
        }
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('auditd').with('has_audisp_config' => true) }
    it { is_expected.to contain_file('/etc/audisp/audispd.conf') }
  end

  context 'Check if wrong email results into a fail' do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'RedHat',
          'release' => {
            'major' => '9',
          }
        }
      }
    end
    let(:params) do
      {
        'action_mail_acct' => 'foobar',
      }
    end

    it { is_expected.to compile.with_all_deps.and_raise_error(/Parameter error: E-Mail address ".*" is not valid./) }
  end

  context 'Check if correct email results into a compiling the catalog' do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'RedHat',
          'release' => {
            'major' => '9',
          }
        }
      }
    end
    let(:params) do
      {
        'action_mail_acct' => 'pete.tom_johnny@test.example.com',
      }
    end

    it { is_expected.to compile.with_all_deps }
  end

  context 'Check if tcp_client_ports act correctly with array' do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'RedHat',
          'release' => {
            'major' => '9',
          }
        }
      }
    end
    let(:params) do
      {
        'krb5_key_file' => '/etc/krb5/key.file',
        'tcp_client_ports' => [666, 1024],
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/audit/auditd.conf').with_content(%r{^tcp_client_ports = 666/1024$}) }
  end
  context 'Check if tcp_client_ports act correctly with String' do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'RedHat',
          'release' => {
            'major' => '9',
          }
        }
      }
    end
    let(:params) do
      {
        'krb5_key_file' => '/etc/krb5/key.file',
        'tcp_client_ports' => 666,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/audit/auditd.conf').with_content(%r{^tcp_client_ports = 666$}) }
  end
  context 'Check if boolean parameters correctly convert' do
    let(:facts) do
      {
        'os' => {
          'family'  => 'RedHat',
          'name'    => 'RedHat',
          'release' => {
            'major' => '9',
          }
        }
      }
    end
    let(:params) do
      {
        'enable_krb5'   => true,
        'krb5_key_file' => '/etc/krb5/key.file',
        'write_logs'    => false,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/audit/auditd.conf').with_content(
      %r{^enable_krb5 = yes$},
      %r{^write_logs = no$},
    )}
  end
end
