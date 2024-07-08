# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PriceHubble::ConfigurationHandling do
  let(:described_class) { PriceHubble }

  before { reset_test_configuration! }

  it 'allows the access of the configuration' do
    expect(described_class.configuration).not_to be_nil
  end

  describe '.configure' do
    it 'yields the configuration' do
      expect do |block|
        described_class.configure(&block)
      end.to yield_with_args(described_class.configuration)
    end
  end

  describe '.reset_configuration!' do
    it 'resets the configuration to its defaults' do
      described_class.configuration.username = 'changed'
      expect { described_class.reset_configuration! }.to \
        change { described_class.configuration.username }
    end
  end

  describe '.identity_params' do
    before do
      described_class.configuration.username = 'username'
      described_class.configuration.password = 'password'
    end

    it 'returns a hash with the credentials' do
      expect(described_class.identity_params).to \
        eql(username: 'username', password: 'password')
    end
  end
end
