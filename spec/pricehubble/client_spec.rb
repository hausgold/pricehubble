# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PriceHubble::Client do
  let(:described_class) { PriceHubble }

  describe '#client' do
    context 'with a string' do
      it 'returns the correct client (PascalCase)' do
        expect(described_class.client('Authentication')).to \
          be_a(PriceHubble::Client::Authentication)
      end

      it 'returns the correct client (snake_case)' do
        expect(described_class.client('authentication')).to \
          be_a(PriceHubble::Client::Authentication)
      end
    end

    context 'with a symbol' do
      it 'returns the correct client (snake_case)' do
        expect(described_class.client(:authentication)).to \
          be_a(PriceHubble::Client::Authentication)
      end

      it 'returns the correct client (PascalCase)' do
        expect(described_class.client(:Authentication)).to \
          be_a(PriceHubble::Client::Authentication)
      end
    end
  end
end
