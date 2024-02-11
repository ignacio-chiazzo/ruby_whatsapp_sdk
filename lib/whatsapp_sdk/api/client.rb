# typed: strict
# frozen_string_literal: true

require "faraday"
require "faraday/multipart"

module WhatsappSdk
  module Api
    class Client
      extend T::Sig

      sig { params(access_token: String).void }
      def initialize(access_token)
        @access_token = access_token
      end

      sig do
        params(
          endpoint: String,
          full_url: T.nilable(String),
          http_method: String,
          params: T::Hash[T.untyped, T.untyped],
          headers: T::Hash[T.untyped, T.untyped],
          multipart: T::Boolean
        ).returns(T.nilable(T::Hash[T.untyped, T.untyped]))
      end
      def send_request(endpoint: "", full_url: nil, http_method: "post", params: {}, headers: {}, multipart: false)
        url = full_url || ApiConfiguration::API_URL

        faraday_request = T.unsafe(faraday(url: url, multipart: multipart))

        response = faraday_request.public_send(http_method, endpoint, request_params(params, headers), headers)

        return nil if response.body == ""

        JSON.parse(response.body)
      end

      sig do
        params(url: String, content_type_header: String, file_path: T.nilable(String))
          .returns(Net::HTTPResponse)
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

      sig do
        params(
          params: T::Hash[T.untyped, T.untyped],
          headers: T::Hash[T.untyped, T.untyped]
        ).returns(T.any(T::Hash[T.untyped, T.untyped], String))
      end
      def request_params(params, headers)
        return params.to_json if params.is_a?(Hash) && headers['Content-Type'] == 'application/json'

        params
      end

      sig { params(url: String, multipart: T::Boolean).returns(Faraday::Connection) }
      def faraday(url:, multipart: false)
        ::Faraday.new(url) do |client|
          client.request(:multipart) if multipart
          client.request(:url_encoded)
          client.adapter(::Faraday.default_adapter)
          client.headers['Authorization'] = "Bearer #{@access_token}" unless @access_token.nil?
        end
      end
    end
  end
end
