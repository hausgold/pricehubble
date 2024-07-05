# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PriceHubble::Utils::Bangers do
  let(:test_class) do
    Class.new do
      include PriceHubble::Utils::Bangers

      def test(bang: false, **_args)
        raise StandardError, 'test' if bang

        false
      end

      def noop; end

      def single(arg)
        arg
      end

      def array(*args)
        args
      end

      def hash(**args)
        args
      end

      def defaults(arg1 = :test, **args)
        [arg1, args]
      end

      bangers :test, :array, :defaults, :hash, :single
    end
  end
  let(:instance) { test_class.new }

  describe 'generates bang variant methods' do
    it 'defines the given methods as bang variants (#test!)' do
      expect(instance.respond_to?(:test!)).to be(true)
    end

    it 'defines the given methods as bang variants (#array!)' do
      expect(instance.respond_to?(:array!)).to be(true)
    end

    it 'defines the given methods as bang variants (#hash!)' do
      expect(instance.respond_to?(:hash!)).to be(true)
    end

    it 'defines the given methods as bang variants (#defaults!)' do
      expect(instance.respond_to?(:defaults!)).to be(true)
    end

    it 'defines the given methods as bang variants (#single!)' do
      expect(instance.respond_to?(:single!)).to be(true)
    end
  end

  describe 'calls the source method' do
    it 'calls the source method with the bang argument' do
      expect(instance).to receive(:test).once.with(bang: true)
      instance.test!
    end

    it 'calls the source method with all additional parameters' do
      expect(instance).to receive(:test).once.with(bang: true, not: :related)
      instance.test!(not: :related)
    end

    it 'returns false on regular method' do
      expect(instance.test(bang: false)).to be(false)
    end

    it 'raises when bang is enabled' do
      expect { instance.test(bang: true) }.to raise_error(StandardError)
    end
  end

  describe 'errors' do
    it 'raise when the source method does not accept parameters' do
      expect { test_class.bangers(:noop) }.to \
        raise_error(ArgumentError, /#noop does not accept arguments/)
    end

    it 'raises when the banger method was called' do
      expect { instance.test! }.to raise_error(StandardError, 'test')
    end
  end

  describe 'argument pass through' do
    it 'passes the arguments correctly (#single)' do
      expect(instance.single!).to eql(bang: true)
    end

    it 'passes the arguments correctly (#array)' do
      expect(instance.array!(1, 2, 3)).to eql([1, 2, 3, { bang: true }])
    end

    it 'passes the arguments correctly, no data (#array)' do
      expect(instance.array!).to eql([{ bang: true }])
    end

    it 'passes the arguments correctly (#hash)' do
      expect(instance.hash!(test: true)).to eql(bang: true, test: true)
    end

    it 'passes the arguments correctly, no data (#hash)' do
      expect(instance.hash!).to eql(bang: true)
    end

    it 'passes the arguments correctly (#defaults)' do
      expect(instance.defaults!(:something)).to \
        eql([:something, { bang: true }])
    end

    it 'passes the arguments correctly, no data (#defaults)' do
      expect(instance.defaults!).to eql([:test, { bang: true }])
    end
  end
end
