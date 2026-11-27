# frozen_string_literal: true

module WhatsappSdk
  module Api
    module Responses
      # HTTP response returned by `send_request(raw_response: true)` when the client is built with
      # `sdk_raw_response: true`, independent of the HTTP library.
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
        def initialize(status:, headers: {}, body: nil)
          @status = status
          @headers = Headers.new(headers || {})
          @body = body
        end

        # @return [Boolean] Whether the status is 2xx.
        def success?
          status >= 200 && status < 300
        end
      end
    end
  end
end
