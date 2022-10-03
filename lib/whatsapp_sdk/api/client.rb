# frozen_string_literal: true
# typed: strict

require "faraday"
require "oj"

module WhatsappSdk
  module Api
    class Client
      extend T::Sig

      API_VERSION = T.let("v14.0", String)
      API_CLIENT = T.let("https://graph.facebook.com/#{API_VERSION}/", String)

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
          headers: T::Hash[T.untyped, T.untyped]
        ).returns(T::Hash[T.untyped, T.untyped])
      end
      def send_request(endpoint: "", full_url: nil, http_method: "post", params: {}, headers: {})
        url = full_url || API_CLIENT

        response = T.unsafe(faraday(url)).public_send(http_method, endpoint, params, headers)
        Oj.load(response.body)
      end

      sig { params(url: String, path_to_file_name: T.nilable(String)).returns(Net::HTTPResponse) }
      def download_file(url, path_to_file_name = nil)
        uri = URI.parse(url)
        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{@access_token}"
        req_options = { use_ssl: uri.scheme == "https" }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end

        File.write(path_to_file_name, response.body) if response.code == "200" && path_to_file_name

        response
      end

      private

      sig { params(url: String).returns(Faraday::Connection) }
      def faraday(url)
        ::Faraday.new(url) do |client|
          client.request :multipart
          client.request :url_encoded
          client.adapter ::Faraday.default_adapter
          client.headers['Authorization'] = "Bearer #{@access_token}" unless @access_token.nil?
        end
      end
    end
  end
end
