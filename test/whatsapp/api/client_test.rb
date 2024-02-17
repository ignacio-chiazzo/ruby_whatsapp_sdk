# typed: true
# frozen_string_literal: true

require 'test_helper'
require 'api/client'
require 'api/api_configuration'

module WhatsappSdk
  module Api
    class ClientTest < Minitest::Test
      def setup(api_version: ApiConfiguration::DEFAULT_API_VERSION)
        @client = Client.new('test_token', api_version)
      end

      def test_send_request_post_with_success_response
        stub_test_request(:post, body: { 'foo' => 'bar' },
                                 headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })

        response_body = @client.send_request(endpoint: 'test',
                                             http_method: 'post',
                                             params: { 'foo' => 'bar' },
                                             headers: {})
        assert_equal({ 'success' => true }, response_body)
      end

      def test_send_request_post_json_content_with_success_response
        stub_test_request(:post, body: { 'foo' => 'bar' }.to_json, headers: { 'Content-Type' => 'application/json' })

        response_body = @client.send_request(endpoint: 'test',
                                             http_method: 'post',
                                             params: { 'foo' => 'bar' },
                                             headers: { 'Content-Type' => 'application/json' })
        assert_equal({ 'success' => true }, response_body)
      end

      def test_send_request_get_with_success_response
        stub_test_request(:get)

        response_body = @client.send_request(endpoint: 'test',
                                             http_method: 'get')
        assert_equal({ 'success' => true }, response_body)
      end

      def test_send_request_delete_with_success_response
        stub_test_request(:delete, response_status: 204, response_body: "")

        response_body = @client.send_request(endpoint: 'test', http_method: 'delete')
        assert_nil(response_body)
      end

      def test_valid_api_version
        invalid_api_version = 'v16.0'
        assert_silent do
          setup(api_version: invalid_api_version)
        end
      end

      def test_invalid_api_version
        invalid_api_version = 'invalid_version'
        assert_raises ArgumentError do
          setup(api_version: invalid_api_version)
        end
      end

      private

      def stub_test_request(method_name, body: {}, headers: {}, response_status: 200, response_body: { success: true },
                            api_version: ApiConfiguration::DEFAULT_API_VERSION)
        stub_request(method_name, "#{ApiConfiguration::API_URL}/#{api_version}/test")
          .with(body: body, headers: { 'Accept' => '*/*',
                                       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                                       'Authorization' => 'Bearer test_token' }.merge(headers))
          .to_return(status: response_status, body: response_body.to_json, headers: {})
      end
    end
  end
end
