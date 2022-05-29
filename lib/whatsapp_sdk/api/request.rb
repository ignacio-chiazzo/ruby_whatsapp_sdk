# frozen_string_literal: true

module WhatsappSdk
  module Api
    class Request
      API_VERSION = "v13.0"
      API_CLIENT = "https://graph.facebook.com/#{API_VERSION}/"

      def initialize(client)
        @client = client
      end

      def send_request(endpoint:, http_method: "post", params: {})
        @client.send_request(http_method: http_method, endpoint: endpoint, params: params)
      end
    end
  end
end
