# frozen_string_literal: true

require "faraday"
require "faraday/multipart"

module WhatsappSdk
  module Api
    class Client
      API_VERSIONS = [
        'v21.0', 'v20.0', 'v19.0', 'v18.0', 'v17.0', 'v16.0', 'v15.0', 'v14.0', 'v13.0', 'v12.0',
        'v11.0', 'v10.0', 'v9.0', 'v8.0', 'v7.0', 'v6.0', 'v5.0', 'v4.0', 'v3.3',
        'v3.2', 'v3.1', 'v3.0', 'v2.12', 'v2.11', 'v2.10', 'v2.9', 'v2.8', 'v2.7',
        'v2.6', 'v2.5', 'v2.4', 'v2.3', 'v2.2', 'v2.1'
      ].freeze

      def initialize(
        access_token = WhatsappSdk.configuration.access_token,
        api_version = ApiConfiguration::DEFAULT_API_VERSION,
        logger = nil,
        logger_options = {}
      )
        @access_token = access_token
        @logger = logger
        @logger_options = logger_options

        validate_api_version(api_version)
        @api_version = api_version
      end

      def media
        @media ||= WhatsappSdk::Api::Medias.new(self)
      end

      def messages
        @messages ||= WhatsappSdk::Api::Messages.new(self)
      end

      def phone_numbers
        @phone_numbers ||= WhatsappSdk::Api::PhoneNumbers.new(self)
      end

      def business_profiles
        @business_profiles ||= WhatsappSdk::Api::BusinessProfile.new(self)
      end

      def templates
        @templates ||= WhatsappSdk::Api::Templates.new(self)
      end

      def send_request(endpoint: "", full_url: nil, http_method: "post", params: {}, headers: {}, multipart: false)
        url = full_url || "#{ApiConfiguration::API_URL}/#{@api_version}/"

        faraday_request = faraday(url: url, multipart: multipart)

        response = faraday_request.public_send(http_method, endpoint, request_params(params, headers), headers)

        if response.status > 499 || Api::Responses::GenericErrorResponse.response_error?(response: response.body)
          raise Api::Responses::HttpResponseError.new(http_status: response.status, body: JSON.parse(response.body))
        end

        return nil if response.body == ""

        JSON.parse(response.body)
      end

      def download_file(url:, content_type_header:, file_path: nil)
        uri = URI.parse(url)
        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{@access_token}"
        request.content_type = content_type_header
        req_options = { use_ssl: uri.scheme == "https" }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end

        File.write(file_path, response.body, mode: 'wb') if response.code == "200" && file_path

        response
      end

      private

      def request_params(params, headers)
        return params.to_json if params.is_a?(Hash) && headers['Content-Type'] == 'application/json'

        params
      end

      def faraday(url:, multipart: false)
        ::Faraday.new(url) do |client|
          client.request(:multipart) if multipart
          client.request(:url_encoded)
          client.adapter(::Faraday.default_adapter)
          client.headers['Authorization'] = "Bearer #{@access_token}" unless @access_token.nil?
          client.response(:logger, @logger, @logger_options) unless @logger.nil?
        end
      end

      def validate_api_version(api_version)
        raise ArgumentError, "Invalid API version: #{api_version}" unless API_VERSIONS.include?(api_version)
      end
    end
  end
end
