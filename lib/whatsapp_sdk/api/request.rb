# frozen_string_literal: true

module WhatsappSdk
  module Api
    class Request
      API_VERSION = "v13.0"
      API_CLIENT = "https://graph.facebook.com/#{API_VERSION}/"

      def initialize(client)
        @client = client
      end

      def download_file(url, path_to_file_name = nil)
        @client.download_file(url, path_to_file_name)
      end

      def send_request(endpoint: nil, full_url: nil, http_method: "post", params: {})
        @client.send_request(
          http_method: http_method, full_url: full_url, endpoint: endpoint, params: params
        )
      end
    end
  end
end
