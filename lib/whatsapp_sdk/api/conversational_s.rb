# typed: strict
# frozen_string_literal: true

require_relative "request"
require_relative "response"

module WhatsappSdk
  module Api
    class ConversationalS < Request
      extend T::Sig

      DEFAULT_HEADERS = {
        "Content-Type" => "application/json"
      }.freeze

      # Send a conversational message.
      #
      # @param sender_id [Integer] Sender's phone number.
      # @param recipient_number [Integer] Recipient's phone number.
      # @param message [String] Text to send.
      # @param message_id [String] The id of the message to reply to.
      # @return [Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer, message: String,
          message_id: T.nilable(String)
        ).returns(Api::Response)
      end
      def send_conversational_message(sender_id:, recipient_number:, message:, message_id: nil)
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "text",
          text: { body: message }
        }
        params[:context] = { message_id: message_id } if message_id

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::MessageDataResponse
        )
      end

      private

      sig { params(sender_id: Integer).returns(String) }
      def endpoint(sender_id)
        "#{sender_id}/conversational"
      end
    end
  end
end
