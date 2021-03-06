require 'spec_helper'

describe 'sensu::agent::label' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:node) { 'localhost' }
      let(:title) { 'cpu.warning' }
      let(:params) { { :value => '90' } }

      it {
        is_expected.to contain_datacat_fragment('sensu_agent_config-label-cpu.warning').with({
          'target' => 'sensu_agent_config',
          'data'   => {
            'labels' => { 'cpu.warning' => '90' },
          },
          'order'  => '50',
        })
      }

      it { is_expected.not_to contain_sensu__agent__config_entry('redact-label-cpu.warning') }

      context 'redact' do
        let(:params) { { :redact => true, :value => '90' } }
        it {
          is_expected.to contain_sensu__agent__config_entry('redact-label-cpu.warning').with({
            'key'   => 'redact',
            'value' => ['cpu.warning'],
          })
        }
      end

      context 'all params' do
        let(:params) do
          {
            :value  => '90',
            :key    => 'cpu.critical',
            :order  => '01',
          }
        end
        it {
          is_expected.to contain_datacat_fragment('sensu_agent_config-label-cpu.warning').with({
            'target' => 'sensu_agent_config',
            'data'   => {
              'labels' => { 'cpu.critical' => '90' },
            },
            'order'  => '01',
          })
        }
      end
    end
  end
end
