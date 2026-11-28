# frozen_string_literal: true

module WhatsappSdk
  module Api
    module Responses
      # Access token returned by `GET /oauth/access_token`.
      # @see Oauth#exchange_token_code
      class AccessTokenResponse
        # @return [String] The access token.
        attr_reader :access_token
        # @return [String, nil] Token type, e.g. "bearer".
        attr_reader :token_type
        # @return [Integer, nil] Seconds until the token expires, or nil when Graph does not return it.
        attr_reader :expires_in

        # @param response [Hash] Parsed Graph response.
        # @return [AccessTokenResponse]
        def self.from_hash(response)
          new(access_token: response["access_token"], token_type: response["token_type"],
              expires_in: response["expires_in"])
        end

        def initialize(access_token:, token_type: nil, expires_in: nil)
          @access_token = access_token
          @token_type = token_type
          @expires_in = expires_in
        end

        # Keeps the token out of logs and consoles.
        def inspect
          "#<#{self.class.name} access_token=[FILTERED] token_type=#{token_type.inspect} " \
            "expires_in=#{expires_in.inspect}>"
        end
      end
    end
  end
end
