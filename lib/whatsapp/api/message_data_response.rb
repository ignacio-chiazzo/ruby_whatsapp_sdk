# frozen_string_literal: true

require_relative "request"
require_relative "data_response"
require_relative "../resource/message"
require_relative "../resource/contact_response"

module Whatsapp
  module Api
    class MessageDataResponse < DataResponse
      attr_reader :contacts, :messages

      def initialize(response:)
        @contacts = response.dig("contacts")&.map { |contact_json| parse_contact(contact_json) }
        @messages = response.dig("messages")&.map { |contact_json| parse_message(contact_json) }
      end

      private

      def self.build_from_response(response:)
        return unless response["messages"]

        new(response: response)
      end

      def parse_message(message_json)
        ::Whatsapp::Resource::Message.new(id: message_json["id"])
      end

      def parse_contact(contact_json)
        ::Whatsapp::Resource::ContactResponse.new(input: contact_json["input"], wa_id: contact_json["wa_id"])
      end
    end
  end
end
