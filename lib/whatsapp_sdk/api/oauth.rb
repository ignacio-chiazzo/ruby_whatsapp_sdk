# frozen_string_literal: true

require_relative 'request'

module WhatsappSdk
  module Api
    # OAuth operations for apps that onboard business customers with Embedded Signup.
    # @see Client#oauth
    # @see https://developers.facebook.com/docs/whatsapp/embedded-signup/onboarding-customers-as-a-solution-partner
    class Oauth < Request
      # Exchange the token code returned by Embedded Signup for a business integration system user access token
      # ("business token"). Sends `GET /oauth/access_token` with `client_id`, `client_secret` and `code`.
      #
      # @param app_id [String, Integer] Your Meta app ID, sent as `client_id`.
      # @param app_secret [String] Your Meta app secret, sent as `client_secret`.
      # @param code [String] Token code returned by Embedded Signup.
      # @return [Responses::AccessTokenResponse] The business token.
      # @raise [Responses::HttpResponseError] If Graph rejects the request, e.g. for an invalid or expired code.
      def exchange_token_code(app_id:, app_secret:, code:)
        response = send_request(
          http_method: "get",
          endpoint: "oauth/access_token",
          params: { client_id: app_id, client_secret: app_secret, code: code }
        )

        Responses::AccessTokenResponse.from_hash(response)
      end
    end
  end
end
