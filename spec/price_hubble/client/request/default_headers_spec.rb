# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PriceHubble::Client::Request::DefaultHeaders do
  let(:app) { proc {} }
  let(:instance) do
    described_class.new.tap do |obj|
      obj.instance_variable_set(:@app, app)
    end
  end

  describe '#call' do
    let(:previously_set_headers) { {} }
    let(:env) do
      { request_headers: previously_set_headers }
    end

    it 'calls the app for the next middleware execution' do
      expect(app).to receive(:call).with(env).once
      instance.call(env)
    end

    context 'with already set user agent header' do
      let(:previously_set_headers) { { 'User-Agent' => 'test' } }

      it 'replaces the user agent header' do
        expect { instance.call(env) }.to \
          change { env[:request_headers]['User-Agent'] }
          .from('test').to(/^PriceHubbleGem/)
      end
    end

    context 'with already set accept header' do
      let(:previously_set_headers) { { 'Accept' => 'test' } }

      it 'replaces the accept header' do
        expect { instance.call(env) }.to \
          change { env[:request_headers]['Accept'] }
          .from('test').to('application/json')
      end
    end

    context 'with already set content type header' do
      let(:previously_set_headers) { { 'Content-Type' => 'test' } }

      it 'does not touch the content type header' do
        expect { instance.call(env) }.not_to \
          change { env[:request_headers]['Content-Type'] }.from('test')
      end
    end

    context 'without already set content type header' do
      it 'sets the fallback content type header' do
        expect { instance.call(env) }.to \
          change { env[:request_headers]['Content-Type'] }
          .from(nil).to('application/json')
      end
    end
  end

  describe '#user_agent' do
    it 'identifies the client' do
      expect(instance.user_agent).to start_with('PriceHubbleGem')
    end

    it 'sets the client version' do
      expect(instance.user_agent).to include(PriceHubble::VERSION)
    end
  end
end
