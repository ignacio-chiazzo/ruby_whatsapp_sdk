# frozen_string_literal: true

require 'test_helper'
require 'api/client'
require 'whatsapp_sdk'

module WhatsappSdk
  module Api
    class OnboardingTest < Minitest::Test
      def test_raw_onboarding_preserves_status_body_and_headers
        operations = [
          ['waba/phone_numbers', lambda {
                                   @client.phone_numbers.add(business_id: 'waba', country_code: '55',
                                                             phone_number: '11999999999', verified_name: 'Store',
                                                             raw_response: true)
                                 }],
          ['phone/request_code', lambda {
                                   @client.phone_numbers.request_code(phone_number_id: 'phone',
                                                                      code_method: 'SMS', language: 'pt_BR',
                                                                      raw_response: true)
                                 }],
          ['phone/verify_code', lambda {
                                  @client.phone_numbers.verify_code(phone_number_id: 'phone',
                                                                    code: '001234', raw_response: true)
                                }],
          ['phone/register', -> { @client.phone_numbers.register_number('phone', '001234', raw_response: true) }],
          ['waba/subscribed_apps', lambda {
                                     @client.business_accounts.subscribe_app(business_id: 'waba', raw_response: true)
                                   }]
        ]
        responses = [[202, '{"id":"phone","success":false,"extra":"preserved"}'], [502, '<html>Bad gateway</html>']]
        operations.each do |endpoint, operation|
          responses.each do |status, body|
            request = stub_request(:post, "https://graph.facebook.com/v24.0/#{endpoint}")
                      .to_return(status: status, body: body, headers: { 'Retry-After' => '30' })
            response = operation.call
            assert_instance_of(Faraday::Response, response)
            assert_equal(status, response.status)
            assert_equal(body, response.body)
            assert_equal('30', response.headers['retry-after'])
            assert_requested(request, times: 1)
            WebMock.reset!
          end
        end
      end

      def setup
        @client = Client.new('store-token', 'v24.0')
      end

      def test_adds_a_phone_number_without_implicitly_requesting_a_code_or_registering
        request = stub_request(:post, 'https://graph.facebook.com/v24.0/waba/phone_numbers')
                  .with(headers: { 'Authorization' => 'Bearer store-token', 'Content-Type' => 'application/json' },
                        body: { cc: '55', phone_number: '11999999999', verified_name: 'Loja São Paulo' }.to_json)
                  .to_return(status: 200, body: '{"id":"phone-id"}')

        result = @client.phone_numbers.add(business_id: 'waba', country_code: '55',
                                           phone_number: '11999999999', verified_name: 'Loja São Paulo')

        assert_equal('phone-id', result.id)
        assert_requested(request, times: 1)
      end

      def test_requests_sms_and_voice_codes_with_explicit_language
        %w[SMS VOICE].each do |method|
          request = stub_request(:post, 'https://graph.facebook.com/v24.0/phone/request_code')
                    .with(headers: { 'Authorization' => 'Bearer store-token' },
                          body: { code_method: method, language: 'pt_BR' }.to_json)
                    .to_return(status: 200, body: '{"success":true}')

          assert(@client.phone_numbers.request_code(phone_number_id: 'phone', code_method: method, language: 'pt_BR'))
          assert_requested(request, times: 1)
        end
      end

      def test_rejects_unsupported_verification_methods_before_http
        assert_raises(ArgumentError) do
          @client.phone_numbers.request_code(phone_number_id: 'phone', code_method: 'EMAIL', language: 'pt_BR')
        end
        assert_not_requested(:post, %r{\Ahttps://graph\.facebook\.com/})
      end

      def test_preserves_leading_zeroes_in_verification_codes
        request = stub_request(:post, 'https://graph.facebook.com/v24.0/phone/verify_code')
                  .with(headers: { 'Authorization' => 'Bearer store-token' }, body: { code: '001234' }.to_json)
                  .to_return(status: 200, body: '{"success":true}')

        assert(@client.phone_numbers.verify_code(phone_number_id: 'phone', code: '001234'))
        assert_requested(request, times: 1)
      end

      def test_subscribes_the_authenticated_app_and_preserves_false_results
        request = stub_request(:post, 'https://graph.facebook.com/v24.0/waba/subscribed_apps')
                  .with(headers: { 'Authorization' => 'Bearer store-token' })
                  .to_return(status: 200, body: '{"success":true}')
                  .then.to_return(status: 200, body: '{"success":false}')

        assert(@client.business_accounts.subscribe_app(business_id: 'waba'))
        refute(@client.business_accounts.subscribe_app(business_id: 'waba'))
        assert_requested(request, times: 2)
      end

      def test_preserves_graph_errors_without_retrying
        request = stub_request(:post, 'https://graph.facebook.com/v24.0/phone/verify_code')
                  .to_return(status: 400,
                             body: '{"error":{"message":"Invalid code","code":100,"type":"OAuthException"}}')

        error = assert_raises(Responses::HttpResponseError) do
          @client.phone_numbers.verify_code(phone_number_id: 'phone', code: '000000')
        end

        assert_equal(400, error.http_status)
        assert_equal(100, error.body.dig('error', 'code'))
        assert_requested(request, times: 1)
      end

      def test_does_not_repeat_code_delivery_after_a_timeout
        request = stub_request(:post, 'https://graph.facebook.com/v24.0/phone/request_code').to_raise(Net::ReadTimeout)

        assert_raises(Faraday::TimeoutError) do
          @client.phone_numbers.request_code(phone_number_id: 'phone', code_method: 'SMS', language: 'en_US')
        end
        assert_requested(request, times: 1)
      end
    end
  end
end
