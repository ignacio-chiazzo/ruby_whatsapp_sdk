# frozen_string_literal: true

module WhatsappSdk
  module Api
    module Responses
      # HTTP response returned by `send_request(raw_response: true)`, independent of the HTTP library.
      class RawResponse
        # Response headers. Keys are stored in lowercase and lookups ignore case.
        class Headers < Hash
          # @param headers [Hash] Header names and values.
          def initialize(headers = {})
            super()
            headers.each { |name, value| store(name.to_s.downcase, value) }
            freeze
          end

          def [](name)
            super(name.to_s.downcase)
          end

          def fetch(name, *args, &block)
            super(name.to_s.downcase, *args, &block)
          end

          def key?(name)
            super(name.to_s.downcase)
          end
          alias has_key? key?
          alias include? key?
          alias member? key?
        end

        # @return [Integer] HTTP status code.
        attr_reader :status
        # @return [Headers] Response headers, with case-insensitive lookup.
        attr_reader :headers
        # @return [String, nil] Unparsed response body.
        attr_reader :body

        # @param status [Integer] HTTP status code.
        # @param headers [Hash] Response headers.
        # @param body [String, nil] Unparsed response body.
        # @param transport_response [Object, nil] @api private The HTTP library's response, kept only so the
        #   deprecated methods below keep working.
        def initialize(status:, headers: {}, body: nil, transport_response: nil)
          @status = status
          @headers = Headers.new(headers || {})
          @body = body
          @transport_response = transport_response
        end

        # @return [Boolean] Whether the status is 2xx.
        def success?
          status >= 200 && status < 300
        end

        # Raw responses used to be Faraday::Response objects. Other Faraday::Response methods still work for now,
        # but warn and will be removed in a future major version.
        def method_missing(name, *args, &block)
          return super unless @transport_response.respond_to?(name)

          warn("[DEPRECATION] WhatsappSdk raw responses are no longer Faraday::Response objects; " \
               "`#{name}` will be removed. Use status, headers, body or success? instead.", uplevel: 1)
          @transport_response.public_send(name, *args, &block)
        end

        def respond_to_missing?(name, include_private = false)
          @transport_response.respond_to?(name) || super
        end
      end
    end
  end
end
