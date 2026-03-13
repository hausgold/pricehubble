# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hash do
  describe '#deep_compact' do
    shared_examples 'deep_compact' do
      let(:action) { input.deep_compact }

      it 'does not modify in place' do
        expect { action }.not_to change { input }
      end

      it 'returns a new hash' do
        expect(action).not_to be(input)
      end

      it 'returns a new hash without nil-values in deep' do
        expect(action).to match(output)
      end
    end

    context 'with an empty hash' do
      let(:input) { {} }
      let(:output) { {} }

      it_behaves_like 'deep_compact'
    end

    context 'with a deeply nested hash, which gets compacted' do
      let(:input) { { a: { c: { e: nil }, d: nil }, b: nil } }
      let(:output) { { a: { c: {} } } }

      it_behaves_like 'deep_compact'
    end

    context 'with a deeply nested hash, keeping a single value' do
      let(:input) { { a: { c: { e: true, f: nil }, d: nil }, b: nil } }
      let(:output) { { a: { c: { e: true } } } }

      it_behaves_like 'deep_compact'
    end

    context 'with a complex and deeply nested hash' do
      let(:input) do
        {
          a: true,
          b: '',
          c: nil,
          d: {
            e: false,
            f: nil,
            g: {
              h: nil,
              i: 'test',
              j: {
                k: nil
              }
            },
            l: [[[{ m: 1, n: nil, o: { p: :test, q: nil } }]]]
          }
        }
      end
      let(:output) do
        {
          a: true,
          b: '',
          d: {
            e: false,
            g: {
              i: 'test',
              j: {}
            },
            l: [[[{ m: 1, o: { p: :test } }]]]
          }
        }
      end

      it_behaves_like 'deep_compact'
    end
  end
end
