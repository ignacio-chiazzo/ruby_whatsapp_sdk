# frozen_string_literal: true

module WhatsappSdk
  module Api
    module Responses
      # HTTP response returned by `send_request(raw_response: true)` when the client is built with
      # `sdk_raw_response: true`, independent of the HTTP library.
      class RawResponse
        # Read-only response headers. Names are stored in lowercase. `[]`, `fetch` and `key?` (and its aliases
        # `has_key?`, `include?` and `member?`) ignore case. `each` and `to_h` yield the lowercase names.
        # It is not a Hash: use `to_h` for other Hash methods.
        class Headers
          include Enumerable

          # @param headers [Hash] Header names and values.
          def initialize(headers = {})
            @headers = {}
            headers.each { |name, value| @headers[name.to_s.downcase] = value }
            @headers.freeze
            freeze
          end

          # @param name [String, Symbol] Header name, in any case.
          # @return [String, nil] The header value, or nil when absent.
          def [](name)
            @headers[name.to_s.downcase]
          end

          # Same as Hash#fetch, with a case-insensitive name.
          def fetch(name, *args, &block)
            @headers.fetch(name.to_s.downcase, *args, &block)
          end

          # @param name [String, Symbol] Header name, in any case.
          # @return [Boolean] Whether the header is present.
          def key?(name)
            @headers.key?(name.to_s.downcase)
          end
          alias has_key? key?
          alias include? key?
          alias member? key?

          # Yields each lowercase header name and its value.
          def each(&block)
            return enum_for(:each) unless block

            @headers.each(&block)
            self
          end

          # @return [Hash] A new, unfrozen Hash with lowercase header names.
          def to_h
            @headers.dup
          end

          def ==(other)
            other.is_a?(Headers) && to_h == other.to_h
          end

          def inspect
            "#<#{self.class.name} #{@headers.inspect}>"
          end
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

        # @return [Boolean] Whether the status is a 2xx Integer.
        def success?
          status.is_a?(Integer) && status >= 200 && status < 300
        end
      end
    end
  end
end
