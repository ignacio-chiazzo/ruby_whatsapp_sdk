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

      sig { params(url: String, content_type_header: String, file_path: T.nilable(String)).void }
      def download_file(url:, content_type_header:, file_path: nil)
        @client.download_file(url: url, content_type_header: content_type_header, file_path: file_path)
      end

      sig do
        params(
          endpoint: T.nilable(String),
          full_url: T.nilable(String),
          http_method: String,
          params: T::Hash[T.untyped, T.untyped],
          headers: T::Hash[T.untyped, T.untyped],
          multipart: T::Boolean
        ).void
      end
      def send_request(endpoint: nil, full_url: nil, http_method: "post", params: {}, headers: {}, multipart: false)
        @client.send_request(
          http_method: http_method,
          full_url: full_url,
          endpoint: endpoint,
          params: params,
          headers: headers,
          multipart: multipart
        )
      end
    end
  end
end
