# frozen_string_literal: true
# typed: true

require_relative "../request"
require_relative "data_response"
require_relative "../../resource/message"
require_relative "../../resource/contact_response"

module WhatsappSdk
  module Api
    module Responses
      class MessageDataResponse < DataResponse
        extend T::Sig

        sig { returns(T::Array[::WhatsappSdk::Resource::ContactResponse]) }
        attr_reader :contacts

        sig { returns(T::Array[::WhatsappSdk::Resource::Message]) }
        attr_reader :messages

        sig { params(response: Hash).void }
        def initialize(response:)
          @contacts = response["contacts"]&.map { |contact_json| parse_contact(contact_json) }
          @messages = response["messages"]&.map { |contact_json| parse_message(contact_json) }
          super(response)
        end

        sig { override.params(response: Hash).returns(T.nilable(DataResponse)) }
        def self.build_from_response(response:)
          return unless response["messages"]

          new(response: response)
        end

        private

        sig { params(message_json: Hash).returns(::WhatsappSdk::Resource::Message) }
        def parse_message(message_json)
          ::WhatsappSdk::Resource::Message.new(id: message_json["id"])
        end

        sig { params(contact_json: Hash).returns(::WhatsappSdk::Resource::ContactResponse) }
        def parse_contact(contact_json)
          ::WhatsappSdk::Resource::ContactResponse.new(input: contact_json["input"], wa_id: contact_json["wa_id"])
        end
      end
    end
  end
end
