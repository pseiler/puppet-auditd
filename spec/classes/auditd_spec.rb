# frozen_string_literal: true

require 'spec_helper'

describe 'auditd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('auditd::params') }
      it { is_expected.to contain_file('/etc/audit/auditd.conf') }
      it { is_expected.to contain_package('auditd') }
      it { is_expected.to contain_service('auditd') }
      it {
        is_expected.to contain_file('/etc/audit/rules.d')
          .with_ensure('directory')
          .with_recurse(true)
          .with_mode('0750')
          .with_require('Package[audit]')
      }
    end
  end
  context "Check if 'manage_service' is acting correctly" do
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
end
