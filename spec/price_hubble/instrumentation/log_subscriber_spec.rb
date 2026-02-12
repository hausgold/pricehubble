# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PriceHubble::Instrumentation::LogSubscriber do
  let(:instance) { described_class.new }
  let(:event) do
    instance_double(ActiveSupport::Notifications::Event,
                    payload: env,
                    duration: 10.44)
  end
  let(:env) { instance_double(Faraday::Env, response:, response_headers:) }
  let(:response) { nil }
  let(:response_headers) { {} }

  before { PriceHubble.configuration.request_logging = true }

  describe '#logger' do
    let(:action) { instance.logger }

    context 'when request logging is enabled' do
      it 'returns configured logger' do
        expect(action).to be_a(Logger)
      end
    end

    context 'when request logging is disabled' do
      before { PriceHubble.configuration.request_logging = false }

      it 'returns nil' do
        expect(action).to be_nil
      end
    end
  end

  describe '#request' do
    let(:action) { instance.request(event) }

    before do
      allow(instance).to receive(:log_action_summary)
      allow(instance).to receive(:log_request_details)
      allow(instance).to receive(:log_response_details)
    end

    after { action }

    it 'logs action summary' do
      expect(instance).to receive(:log_action_summary).with(event)
    end

    it 'logs request details' do
      expect(instance).to receive(:log_request_details).with(event)
    end

    it 'logs response details' do
      expect(instance).to receive(:log_response_details).with(event)
    end
  end

  describe '#log_action_summary' do
    let(:action) { instance.log_action_summary(event) }

    before do
      allow(instance).to receive(:req_id).with(env).and_return('RID')
      allow(instance).to receive(:req_origin).with(env).and_return('origin')
      allow(instance).to receive(:res_result).with(env).and_return('200/OK')
    end

    it 'writes formatted info log line' do
      expect { action }.to \
        log_at_level(:info, '[RID] origin -> 200/OK (10.4ms)')
    end
  end

  describe '#log_request_details' do
    let(:action) { instance.log_request_details(event) }
    let(:env) { instance_double(Faraday::Env, request_headers: headers) }
    let(:headers) { { 'b' => '2', 'a' => '1' } }

    before do
      allow(instance).to receive(:req_id).with(env).and_return('RID')
      allow(instance).to receive(:req_dest).with(env).and_return('DEST')
    end

    it 'writes formatted debug log line' do
      action_json = headers.sort.to_h.to_json
      expect { action }.to \
        log_at_level(:debug, "[RID] DEST > #{action_json}")
    end
  end

  describe '#log_response_details' do
    before do
      allow(instance).to receive(:req_id).with(env).and_return('RID')
      allow(instance).to receive(:req_dest).with(env).and_return('DEST')
      allow(instance).to receive(:res_result).with(env).and_return('RES')
    end

    context 'when response is nil' do
      let(:action) { instance.log_response_details(event) }

      it 'writes error log line' do
        expect { action }.to log_at_level(:error, '[RID] DEST < RES')
      end
    end

    context 'when response is present' do
      let(:action) { instance.log_response_details(event) }
      let(:response) { instance_double(Object) }
      let(:response_headers) { { 'x' => '1', 'a' => '2' } }

      it 'writes debug log line with headers' do
        headers_json = response_headers.sort.to_h.to_json
        expect { action }.to \
          log_at_level(:debug, "[RID] DEST < #{headers_json}")
      end
    end
  end

  describe '#req_dest' do
    let(:action) { instance.req_dest(env) }
    let(:env) do
      {
        method: :get,
        url: 'https://example.test?access_token=secret&x=1'
      }
    end

    before do
      allow(instance).to receive(:color_method).with('GET').and_return(:blue)
      allow(instance).to receive(:color).and_return('GET')
    end

    it 'filters access token from url' do
      expect(action).to include('access_token=[FILTERED]')
    end
  end

  describe '#res_result' do
    let(:action) { instance.res_result(env) }

    context 'when response is nil' do
      it 'returns colored no response text' do
        expect(action).to eq("\e[1m\e[31mno response\e[0m")
      end
    end

    context 'when response is present' do
      let(:env) do
        Faraday::Env.new(status: 200,
                         reason_phrase: 'OK',
                         response: instance_double(Object))
      end

      it 'returns colored status string' do
        expect(action).to eq("\e[1m\e[32m200/OK\e[0m")
      end
    end
  end
end
