# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/ClassVars -- because we split module code
RSpec.describe PriceHubble::Identity do
  let(:described_class) { PriceHubble }

  before { reset_test_configuration! }

  describe '.reset_identity!' do
    before { described_class.class_variable_set(:@@identity, 'something') }

    it 'clears any previous identity' do
      expect { described_class.reset_identity! }.to \
        (change { described_class.class_variable_get(:@@identity) })
        .from('something').to(nil)
    end
  end

  describe '.identity' do
    context 'with invalid credentials' do
      before do
        described_class.configuration.username = 'test'
        described_class.configuration.password = 'test'
      end

      it 'raises an PriceHubble::AuthenticationError' do
        expect { described_class.identity }.to \
          raise_error(PriceHubble::AuthenticationError)
      end
    end

    context 'with valid credentials' do
      context 'with unset cache' do
        it 'returns an PriceHubble::Authentication' do
          expect(described_class.identity).to \
            be_a(PriceHubble::Authentication)
        end

        it 'responds false to the expired? reader' do
          expect(described_class.identity.expired?).to be(false)
        end
      end

      context 'with unexpired cache' do
        # rubocop:disable RSpec/IdenticalEqualityAssertion -- because we want
        #   to test for memoized results
        it 'caches the authentication' do
          expect(described_class.identity).to be(described_class.identity)
        end
        # rubocop:enable RSpec/IdenticalEqualityAssertion
      end

      context 'with expired cache' do
        let(:auth) { PriceHubble::Authentication.new(expires_in: -300) }

        before { described_class.class_variable_set(:@@identity, auth) }

        it 'renews the authentication' do
          expect { described_class.identity }.to \
            (change { described_class.class_variable_get(:@@identity) })
            .from(auth)
        end
      end
    end
  end
end
# rubocop:enable Style/ClassVars
