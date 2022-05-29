# frozen_string_literal: true

require_relative "../request"
require_relative "data_response"
require_relative "../../resource/message"
require_relative "../../resource/contact_response"

module WhatsappSdk
  module Api
    module Responses
      class MessageDataResponse < DataResponse
        attr_reader :contacts, :messages

        def initialize(response:)
          @contacts = response["contacts"]&.map { |contact_json| parse_contact(contact_json) }
          @messages = response["messages"]&.map { |contact_json| parse_message(contact_json) }
          super(response)
        end

        def self.build_from_response(response:)
          return unless response["messages"]

          new(response: response)
        end

        private

        def parse_message(message_json)
          ::WhatsappSdk::Resource::Message.new(id: message_json["id"])
        end

        def parse_contact(contact_json)
          ::WhatsappSdk::Resource::ContactResponse.new(input: contact_json["input"], wa_id: contact_json["wa_id"])
        end
      end
    end
  end
end
