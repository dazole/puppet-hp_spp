#!/usr/bin/env rspec

require 'spec_helper'

describe 'hp_spp::repo', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'foo'
    }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Unsupported osfamily: foo operatingsystem: foo, module hp_spp only support operatingsystem/)
      }
    end
  end

  context 'on a supported operatingsystem, non-HP platform' do
    (['RedHat']).each do |os|
      context "for operatingsystem #{os}" do
        let(:params) {{}}
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'foo'
        }
        end
        it { should_not contain_yumrepo('HP-spp') }
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, default parameters' do
    (['RedHat']).each do |os|
      context "for operatingsystem #{os}" do
        let(:params) {{}}
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'HP'
        }
        end
        it { should contain_yumrepo('HP-spp').with(
          :descr    => 'HP Software Delivery Repository for Service Pack for ProLiant',
          :enabled  => '1',
          :gpgcheck => '1',
          :gpgkey   => 'http://downloads.linux.hp.com/SDR/hpPublicKey1024.pub
    http://downloads.linux.hp.com/SDR/hpPublicKey2048.pub',
          :baseurl  => 'http://downloads.linux.hp.com/SDR/repo/spp/RedHat/$releasever/$basearch/current/',
          :priority => '50',
          :protect  => '0'
        )}
      end
    end
  end

end
