# typed: true
# frozen_string_literal: true

module WhatsappSdk
  module Api
    class Request
      extend T::Sig

      def initialize(client = WhatsappSdk.configuration.client)
        @client = client
      end

      def download_file(url, path_to_file_name = nil)
        @client.download_file(url, path_to_file_name)
      end

      def send_request(endpoint: nil, full_url: nil, http_method: "post", params: {}, headers: {})
        @client.send_request(
          http_method: http_method, full_url: full_url, endpoint: endpoint, params: params, headers: headers
        )
      end
    end
  end
end
