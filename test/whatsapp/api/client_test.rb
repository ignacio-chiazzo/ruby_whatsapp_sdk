# typed: true
# frozen_string_literal: true

require 'test_helper'
require 'api/client'
require 'api/api_configuration'
require 'webmock/minitest'

module WhatsappSdk
  module Api
    class ClientTest < Minitest::Test
      def setup(api_version: ApiConfiguration::DEFAULT_API_VERSION)
        @client = Client.new('test_token', api_version)
      end

      def test_send_request_post_with_success_response
        stub_test_request(method_name: :post, body: { 'foo' => 'bar' },
                                 headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })

        response_body = @client.send_request(endpoint: 'test',
                                             http_method: 'post',
                                             params: { 'foo' => 'bar' },
                                             headers: {})
        assert_equal({ 'success' => true }, response_body)
      end

      def test_send_request_post_json_content_with_success_response
        stub_test_request(method_name: :post, body: { 'foo' => 'bar' }.to_json, headers: { 'Content-Type' => 'application/json' })

        response_body = @client.send_request(endpoint: 'test',
                                             http_method: 'post',
                                             params: { 'foo' => 'bar' },
                                             headers: { 'Content-Type' => 'application/json' })
        assert_equal({ 'success' => true }, response_body)
      end

      def test_send_request_get_with_success_response
        stub_test_request(method_name: :get)

        response_body = @client.send_request(endpoint: 'test', http_method: 'get')
        assert_equal({ 'success' => true }, response_body)
      end

      def test_send_request_delete_with_success_response
        stub_test_request(method_name: :delete, response_status: 204, response_body: "")

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

      def test_logs_http_requests_into_the_logger_without_response_body
        logger_io = StringIO.new
        client = Client.new('test_token', ApiConfiguration::DEFAULT_API_VERSION, Logger.new(logger_io))

        stub_test_request(method_name: :get)
        client.send_request(endpoint: 'test', http_method: 'get')

        logged_string = logger_io.string
        middleware_handlers = faraday_middlewares(client)

        assert_includes(middleware_handlers, Faraday::Response::Logger)
        assert_match_logger_output!(logged_string)
        assert_match('INFO -- response: ', logged_string)
      end

      def test_logs_http_requests_into_the_logger_with_response_body
        logger_io = StringIO.new
        client = Client.new(
          'test_token',
          ApiConfiguration::DEFAULT_API_VERSION,
          Logger.new(logger_io),
          { bodies: true }
        )

        stub_test_request(method_name: :get)
        client.send_request(endpoint: 'test', http_method: 'get')

        logged_string = logger_io.string
        assert_match_logger_output!(logged_string)
        assert_match('INFO -- response: {"success":true}', logged_string)
      end

      def test_should_not_log_when_logger_not_configured
        # Validates whether the logger was configured into faraday or not
        middleware_handlers = faraday_middlewares(@client)
        refute_includes(middleware_handlers, Faraday::Response::Logger)
      end

      private

      def stub_test_request(method_name:, body: {}, headers: {}, response_status: 200, response_body: { success: true },
                            api_version: ApiConfiguration::DEFAULT_API_VERSION)
        WebMock.stub_request(method_name, "#{ApiConfiguration::API_URL}/#{api_version}/test")
          .with(body: body, headers: { 'Accept' => '*/*',
                                       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                                       'Authorization' => 'Bearer test_token' }.merge(headers))
          .to_return(status: response_status, body: response_body.to_json, headers: {})
      end

      def faraday_middlewares(client)
        faraday = client.send(:faraday, url: '')
        faraday.builder.handlers
      end

      def assert_match_logger_output!(logged_string)
        assert_match('INFO -- request: GET https://graph.facebook.com/v19.0/test', logged_string)
        assert_match('INFO -- request: Authorization: "Bearer test_token"', logged_string)
        assert_match('User-Agent: "Faraday', logged_string)
        assert_match('INFO -- response: Status 200', logged_string)
      end
    end
  end
end
