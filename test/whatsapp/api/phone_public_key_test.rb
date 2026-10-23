# frozen_string_literal: true

require 'test_helper'
require 'whatsapp_sdk'

module WhatsappSdk
  module Api
    class PhonePublicKeyTest < Minitest::Test
      def setup
        @client = Client.new('phone-token', 'v24.0')
      end

      def test_sets_the_public_key_preserving_pem_newlines_and_base64_characters
        key = "-----BEGIN PUBLIC KEY-----\nTEST+PUBLIC/KEY==\n-----END PUBLIC KEY-----\n"
        request = stub_request(:post, 'https://graph.facebook.com/v24.0/phone/whatsapp_business_encryption')
                  .with(headers: { 'Authorization' => 'Bearer phone-token',
                                   'Content-Type' => 'application/x-www-form-urlencoded' },
                        body: { 'business_public_key' => key })
                  .to_return(body: '{"success":true}').then.to_return(body: '{"success":false}')

        assert(@client.phone_numbers.set_public_key(phone_number_id: 'phone', business_public_key: key))
        refute(@client.phone_numbers.set_public_key(phone_number_id: 'phone', business_public_key: key))
        assert_requested(request, times: 2)
      end

      def test_reads_the_public_key_and_signature_status_without_hiding_a_mismatch
        key = { 'business_public_key' => 'stored-public-key', 'business_public_key_signature_status' => 'MISMATCH' }
        data = { 'data' => [key] }
        request = stub_request(:get, 'https://graph.facebook.com/v24.0/phone/whatsapp_business_encryption')
                  .with(headers: { 'Authorization' => 'Bearer phone-token' }).to_return(body: data.to_json)

        result = @client.phone_numbers.get_public_key(phone_number_id: 'phone')

        assert_equal(data, result)
        assert_equal('MISMATCH', result.dig('data', 0, 'business_public_key_signature_status'))
        assert_requested(request, times: 1)
      end

      def test_raw_key_configuration_keeps_the_full_http_response
        request = stub_request(:post, 'https://graph.facebook.com/v24.0/phone/whatsapp_business_encryption')
                  .to_return(status: 202, body: '{"success":true,"extra":"preserved"}')
                  .then.to_return(status: 403, body: '<html>Forbidden</html>')

        response = @client.phone_numbers.set_public_key(phone_number_id: 'phone', business_public_key: 'key',
                                                        raw_response: true)
        assert_equal(202, response.status)
        assert_equal('{"success":true,"extra":"preserved"}', response.body)
        response = @client.phone_numbers.set_public_key(phone_number_id: 'phone', business_public_key: 'key',
                                                        raw_response: true)
        assert_equal(403, response.status)
        assert_equal('<html>Forbidden</html>', response.body)
        assert_requested(request, times: 2)
      end

      def test_preserves_graph_errors_for_key_configuration
        body = { error: { message: 'Permission denied', code: 200, type: 'OAuthException' } }.to_json
        key = stub_request(:post, 'https://graph.facebook.com/v24.0/phone/whatsapp_business_encryption')
              .to_return(status: 403, body: body)

        assert_raises(Responses::HttpResponseError) do
          @client.phone_numbers.set_public_key(phone_number_id: 'phone', business_public_key: 'public-key')
        end
        assert_requested(key, times: 1)
      end
    end
  end
end
