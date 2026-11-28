# frozen_string_literal: true

require 'test_helper'
require 'api/client'
require 'api/oauth'

module WhatsappSdk
  module Api
    # The stubs are written by hand from Meta's Embedded Signup docs and the Graph API error format.
    class OauthTest < Minitest::Test
      TOKEN_URL = 'https://graph.facebook.com/v24.0/oauth/access_token'
      QUERY = { client_id: '1234567890', client_secret: 'app-secret', code: 'signup-code' }.freeze

      def setup
        @client = Client.new('partner-token', 'v24.0')
      end

      def test_exchange_token_code_returns_the_business_token
        request = stub_request(:get, TOKEN_URL)
                  .with(query: QUERY)
                  .to_return(status: 200, body: '{"access_token":"business-token","token_type":"bearer"}',
                             headers: { 'Content-Type' => 'application/json' })

        token = @client.oauth.exchange_token_code(app_id: 1_234_567_890, app_secret: 'app-secret',
                                                  code: 'signup-code')

        assert_requested(request, times: 1)
        assert_instance_of(Responses::AccessTokenResponse, token)
        assert_equal('business-token', token.access_token)
        assert_equal('bearer', token.token_type)
        assert_nil(token.expires_in)
      end

      def test_exchange_token_code_returns_expires_in_when_present
        stub_request(:get, TOKEN_URL).with(query: QUERY)
                                     .to_return(status: 200,
                                                body: '{"access_token":"business-token","token_type":"bearer",' \
                                                      '"expires_in":5183944}')

        token = Oauth.new(@client).exchange_token_code(app_id: '1234567890', app_secret: 'app-secret',
                                                       code: 'signup-code')

        assert_equal(5_183_944, token.expires_in)
      end

      def test_exchange_token_code_raises_on_graph_error
        body = {
          error: {
            message: 'Invalid verification code format.',
            type: 'OAuthException',
            code: 100,
            error_subcode: 36_007,
            fbtrace_id: 'trace-id'
          }
        }.to_json
        stub_request(:get, TOKEN_URL).with(query: QUERY).to_return(status: 400, body: body)

        error = assert_raises(Responses::HttpResponseError) do
          @client.oauth.exchange_token_code(app_id: '1234567890', app_secret: 'app-secret', code: 'signup-code')
        end

        assert_equal(400, error.http_status)
        assert_equal(100, error.error_info.code)
        assert_equal(36_007, error.error_info.subcode)
        assert_equal('OAuthException', error.error_info.type)
        assert_equal('Invalid verification code format.', error.error_info.message)
      end

      def test_access_token_response_inspect_hides_the_token
        token = Responses::AccessTokenResponse.new(access_token: 'business-token', token_type: 'bearer')

        refute_includes(token.inspect, 'business-token')
        assert_includes(token.inspect, '[FILTERED]')
      end

      def test_client_caches_the_oauth_accessor
        assert_instance_of(Oauth, @client.oauth)
        assert_same(@client.oauth, @client.oauth)
      end
    end
  end
end
