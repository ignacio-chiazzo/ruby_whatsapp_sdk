# typed: strict
# frozen_string_literal: true

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

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response:)
          @contacts = T.let(
            response["contacts"]&.map { |contact_json| parse_contact(contact_json) },
            T::Array[::WhatsappSdk::Resource::ContactResponse]
          )
          @messages = T.let(
            response["messages"]&.map { |contact_json| parse_message(contact_json) },
            T::Array[::WhatsappSdk::Resource::Message]
          )
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(MessageDataResponse)) }
        def self.build_from_response(response:)
          return unless response["messages"]

          new(response: response)
        end

        private

        sig { params(message_json: T::Hash[T.untyped, T.untyped]).returns(::WhatsappSdk::Resource::Message) }
        def parse_message(message_json)
          ::WhatsappSdk::Resource::Message.new(id: message_json["id"])
        end

        sig { params(contact_json: T::Hash[T.untyped, T.untyped]).returns(::WhatsappSdk::Resource::ContactResponse) }
        def parse_contact(contact_json)
          ::WhatsappSdk::Resource::ContactResponse.new(input: contact_json["input"], wa_id: contact_json["wa_id"])
        end
      end
    end
  end
end
