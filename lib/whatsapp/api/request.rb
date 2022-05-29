module Whatsapp
  module Api
    class Request
      # TODO Make it a module
      API_VERSION = "v13.0"
      API_CLIENT = "https://graph.facebook.com/#{API_VERSION}/"

      def initialize(client)
        @client = client
      end

      def send_request(http_method: "post", endpoint:, params: {})
        @client.send_request(http_method: http_method, endpoint: endpoint, params: params)
      end
    end
  end
end
