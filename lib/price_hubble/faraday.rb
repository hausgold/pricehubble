# frozen_string_literal: true

# Register our custom faraday middlewares
Faraday::Request.register_middleware \
  ph_data_sanitization: PriceHubble::Client::Request::DataSanitization
Faraday::Request.register_middleware \
  ph_default_headers: PriceHubble::Client::Request::DefaultHeaders

Faraday::Response.register_middleware \
  ph_data_sanitization: PriceHubble::Client::Response::DataSanitization
Faraday::Response.register_middleware \
  ph_recursive_open_struct: PriceHubble::Client::Response::RecursiveOpenStruct
