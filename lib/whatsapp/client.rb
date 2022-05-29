# frozen_string_literal: true

require "faraday"
require "oj"

module Whatsapp
  class Client
    API_VERSION = "v13.0"
    API_CLIENT = "https://graph.facebook.com/#{API_VERSION}/"

    def initialize(access_token)
      @access_token = access_token
    end

    def client
      @client ||= ::Faraday.new(API_CLIENT) do |client|
        client.request :url_encoded
        client.adapter ::Faraday.default_adapter
        client.headers['Authorization'] = "Bearer #{@access_token}" unless @access_token.nil?
      end
    end

    def send_request(endpoint:, http_method: "post", params: {})
      response = client.public_send(http_method, endpoint, params)
      Oj.load(response.body)
    end
  end
end
