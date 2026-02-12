# frozen_string_literal: true

module PriceHubble
  module Instrumentation
    # Produce logs for requests.
    class LogSubscriber < ActiveSupport::LogSubscriber
      # Return the PriceHubble SDK configured logger when logging is enabled.
      # Otherwise +nil+ is returned and the subscriber is never started.
      #
      # @return [Logger, nil] the logger to use
      def logger
        return unless PriceHubble.configuration.request_logging

        PriceHubble.configuration.logger
      end

      # Log request statistics and debugging details.
      #
      # @param event [ActiveSupport::Notifications::Event] the subscribed event
      def request(event)
        log_action_summary(event)
        log_request_details(event)
        log_response_details(event)
      end

      # Print some top-level request/action details.
      #
      # @param event [ActiveSupport::Notifications::Event] the subscribed event
      def log_action_summary(event)
        env = event.payload
        info do
          "[#{req_id(env)}] #{req_origin(env)} -> #{res_result(env)} " \
            "(#{event.duration.round(1)}ms)"
        end
      end

      # Print details about the request.
      #
      # @param event [ActiveSupport::Notifications::Event] the subscribed event
      def log_request_details(event)
        env = event.payload
        debug do
          "[#{req_id(env)}] #{req_dest(env)} > " \
            "#{env.request_headers.sort.to_h.to_json}"
        end
      end

      # When no response is available (due to timeout, DNS resolve issues, etc)
      # we just can log an error without details. Otherwise print details about
      # the response.
      #
      # @param event [ActiveSupport::Notifications::Event] the subscribed event
      def log_response_details(event)
        env = event.payload

        if env.response.nil?
          return error do
            "[#{req_id(env)}] #{req_dest(env)} < #{res_result(env)}"
          end
        end

        debug do
          "[#{req_id(env)}] #{req_dest(env)} < " \
            "#{env.response_headers.sort.to_h.to_json}"
        end
      end

      # Format the request identifier.
      #
      # @param env [Faraday::Env] the request/response environment
      # @return [String] the request identifier
      def req_id(env)
        env.request.context[:request_id].to_s
      end

      # Format the request/action origin.
      #
      # @param env [Faraday::Env] the request/response environment
      # @return [String] the request identifier
      def req_origin(env)
        req = env.request.context
        action = req[:action]
        action = color(action, color_method(action), bold: true)
        client = req[:client].to_s.gsub('PriceHubble::Client', 'PriceHubble')
        "#{client.underscore}##{action}"
      end

      # Format the request destination.
      #
      # @param env [Faraday::Env] the request/response environment
      # @return [String] the request identifier
      def req_dest(env)
        method = env[:method].to_s.upcase
        method = color(method, color_method(method), bold: true)
        url = env[:url].to_s.gsub(/access_token=[^&]+/,
                                  'access_token=[FILTERED]')
        "#{method} #{url}"
      end

      # Format the request result.
      #
      # @param env [Faraday::Env] the request/response environment
      # @return [String] the request identifier
      def res_result(env)
        return color('no response', RED, bold: true).to_s if env.response.nil?

        status = env[:status]
        color("#{status}/#{env[:reason_phrase]}",
              color_status(status),
              bold: true)
      end

      # Decide which color to use for the given HTTP status code.
      #
      # @param status [Integer] the HTTP status code
      # @return [String] the ANSI color code
      def color_status(status)
        case status
        when 0..199 then MAGENTA
        when 200..299 then GREEN
        when 300..399 then YELLOW
        when 400..599 then RED
        else WHITE
        end
      end

      # Decide which color to use for the given HTTP/client method.
      #
      # @param method [String] the method to inspect
      # @return [String] the ANSI color code
      def color_method(method)
        case method
        when /delete/i then RED
        when /get|search|reload|find/i then BLUE
        when /post|create/i then GREEN
        when /put|patch|update/i then YELLOW
        when /login|logout|download|query/i then CYAN
        else MAGENTA
        end
      end
    end
  end
end
