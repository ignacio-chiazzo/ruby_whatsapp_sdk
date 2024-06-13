# typed: true
# frozen_string_literal: true

module WhatsappSdk
  module Api
    class Request
      extend T::Sig

      sig { params(client: T.untyped).void }
      def initialize(client = WhatsappSdk.configuration.client)
        @client = client
      end

      sig { params(url: String, content_type_header: String, file_path: T.nilable(String)).returns(T::Hash[T.untyped, T.untyped]) }
      def download_file(url:, content_type_header:, file_path: nil)
        response = @client.download_file(url: url, content_type_header: content_type_header, file_path: file_path)
        {
          "code" => response.code,
          "body" => response.body,
          "success" => response.code.to_i == 200,
          "error" => response.code.to_i != 200
        }
      end

      sig do
        params(
          endpoint: T.nilable(String),
          full_url: T.nilable(String),
          http_method: String,
          params: T::Hash[T.untyped, T.untyped],
          headers: T::Hash[T.untyped, T.untyped],
          multipart: T::Boolean
        ).returns(T.nilable(T::Hash[T.untyped, T.untyped]))
      end
      def send_request(endpoint: nil, full_url: nil, http_method: "post", params: {}, headers: {}, multipart: false)
        response = @client.send_request(
          http_method: http_method,
          full_url: full_url,
          endpoint: endpoint,
          params: params,
          headers: headers,
          multipart: multipart
        )
        response.nil? ? nil : { "code" => response.code, "body" => response.body }
      end
    end
  end
end
