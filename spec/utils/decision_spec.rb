# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PriceHubble::Utils::Decision do
  let(:test_class) { Class.new { include(PriceHubble::Utils::Decision) } }
  let(:instance) { test_class.new }

  describe '#decision' do
    let(:good_proc) { -> { :good } }
    let(:fail_proc) { -> { :fail } }
    let(:bang_proc) { -> { PriceHubble::EntityNotFound.new } }
    let(:decision) do
      lambda do |opts|
        instance.decision(bang: opts[:bang]) do |result|
          result.good(&good_proc)
          result.fail(&fail_proc)
          result.bang(&bang_proc)
          opts[:result]
        end
      end
    end

    context 'without bang' do
      it 'evaluates correctly the good path' do
        expect(good_proc).to receive(:call).once
        decision[bang: false, result: true]
      end

      it 'evaluates correctly the fail path' do
        expect(fail_proc).to receive(:call).once
        decision[bang: false, result: false]
      end

      it 'does not call the bang block on error' do
        expect(bang_proc).not_to receive(:call)
        decision[bang: false, result: false]
      end

      it 'does not call the good block on error' do
        expect(good_proc).not_to receive(:call)
        decision[bang: false, result: false]
      end

      it 'does not call the fail block on success' do
        expect(fail_proc).not_to receive(:call)
        decision[bang: false, result: true]
      end

      it 'does not call the bang block on success' do
        expect(bang_proc).not_to receive(:call)
        ignore_raise { decision[bang: false, result: true] }
      end

      it 'returns the result of good block on success' do
        expect(decision[bang: false, result: true]).to be(:good)
      end

      it 'returns the result of fail block on error' do
        expect(decision[bang: false, result: false]).to be(:fail)
      end

      it 'returns the default result of good block on success' do
        output = instance.decision(bang: false) { true }
        expect(output).to be_nil
      end

      it 'returns the default result of fail block on error' do
        output = instance.decision(bang: false) { false }
        expect(output).to be_nil
      end
    end

    context 'with bang' do
      it 'evaluates correctly the good path' do
        expect(good_proc).to receive(:call).once
        ignore_raise { decision[bang: true, result: true] }
      end

      it 'evaluates correctly the bang path' do
        expect(bang_proc).to receive(:call).once
        ignore_raise { decision[bang: true, result: false] }
      end

      it 'does not call the fail block on error' do
        expect(fail_proc).not_to receive(:call)
        ignore_raise { decision[bang: true, result: false] }
      end

      it 'does not call the good block on error' do
        expect(good_proc).not_to receive(:call)
        ignore_raise { decision[bang: true, result: false] }
      end

      it 'does not call the fail block on success' do
        expect(fail_proc).not_to receive(:call)
        ignore_raise { decision[bang: true, result: true] }
      end

      it 'does not call the bang block on success' do
        expect(bang_proc).not_to receive(:call)
        ignore_raise { decision[bang: true, result: true] }
      end

      it 'returns the result of good block on success' do
        output = ignore_raise { decision[bang: true, result: true] }
        expect(output).to be(:good)
      end

      it 'raise the error object from the bang block on error' do
        expect { decision[bang: true, result: false] }.to \
          raise_error(PriceHubble::EntityNotFound)
      end

      it 'returns the default result of good block on success' do
        output = instance.decision(bang: true) { true }
        expect(output).to be_nil
      end

      it 'raises the default error object of bang block on error' do
        expect { instance.decision(bang: true) { false } }.to \
          raise_error(StandardError)
      end
    end
  end
end
