# frozen_string_literal: true

require 'spec_helper'

describe 'auditd::rule', type: 'define' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      content: '',
      order: '01',
    }
  end
  let(:pre_condition) do
    [
      'include auditd',
    ]
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(
        'networking' => {
          'hostname' => 'testserver.example.com',
        }
      )}

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_concat__fragment('auditd_fragment_namevar').with(
        'content' => 'namevar',
        'order'   => '01',
      )}
    end
  end
end
