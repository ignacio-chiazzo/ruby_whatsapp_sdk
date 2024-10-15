# frozen_string_literal: true

require_relative "../../resource/message"
require_relative "../../resource/contact_response"

module WhatsappSdk
  module Api
    module Responses
      class MessageDataResponse
        attr_accessor :contacts, :messages

        class << self
          def build_from_response(response:)
            return unless response["messages"]

            data_response = new
            data_response.contacts = response["contacts"]&.map { |contact_json| parse_contact(contact_json) }
            data_response.messages = response["messages"]&.map { |contact_json| parse_message(contact_json) }

            data_response
          end

          private

          def parse_message(message_json)
            Resource::Message.new(id: message_json["id"])
          end

          def parse_contact(contact_json)
            Resource::ContactResponse.new(input: contact_json["input"], wa_id: contact_json["wa_id"])
          end
        end
      end
    end
  end
end
