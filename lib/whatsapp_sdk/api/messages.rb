# typed: strict
# frozen_string_literal: true

require_relative "request"
require_relative "response"

module WhatsappSdk
  module Api
    class Messages < Request
      extend T::Sig

      DEFAULT_HEADERS = T.let({ 'Content-Type' => 'application/json' }.freeze, Hash)

      class MissingArgumentError < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :message

        sig { params(message: String).void }
        def initialize(message)
          @message = message
          super(message)
        end
      end

      # Send a text message.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param message [String] Text to send.
      # @param message_id [String] The id of the message to reply to.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer, message: String,
          message_id: T.nilable(String)
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_text(sender_id:, recipient_number:, message:, message_id: nil)
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

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      # Send location.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param longitude [Float] Location longitude.
      # @param latitude [Float] Location latitude.
      # @param name [String] Location name.
      # @param address [String] Location address.
      # @param message_id [String] The id of the message to reply to.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer,
          longitude: Float, latitude: Float, name: String, address: String,
          message_id: T.nilable(String)
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_location(
        sender_id:, recipient_number:, longitude:, latitude:, name:, address:, message_id: nil
      )
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "location",
          location: {
            longitude: longitude,
            latitude: latitude,
            name: name,
            address: address
          }
        }
        params[:context] = { message_id: message_id } if message_id

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      # Send an image.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param image_id [String] Image ID.
      # @param link [String] Image link.
      # @param caption [String] Image caption.
      # @param message_id [String] The id of the message to reply to.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer, image_id: T.nilable(String),
          link: T.nilable(String), caption: T.nilable(String),
          message_id: T.nilable(String)
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_image(
        sender_id:, recipient_number:, image_id: nil, link: nil, caption: "", message_id: nil
      )
        raise MissingArgumentError, "image_id or link is required" if !image_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "image"
        }
        params[:image] = if link
                           { link: link, caption: caption }
                         else
                           { id: image_id, caption: caption }
                         end
        params[:context] = { message_id: message_id } if message_id

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      # Send an audio.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param audio_id [String] Audio ID.
      # @param link [String] Audio link.
      # @param message_id [String] The id of the message to reply to.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer, audio_id: T.nilable(String),
          link: T.nilable(String), message_id: T.nilable(String)
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_audio(sender_id:, recipient_number:, audio_id: nil, link: nil, message_id: nil)
        raise MissingArgumentError, "audio_id or link is required" if !audio_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "audio"
        }
        params[:audio] = link ? { link: link } : { id: audio_id }
        params[:context] = { message_id: message_id } if message_id

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      # Send a video.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param video_id [String] Video ID.
      # @param link [String] Image link.
      # @param caption [String] Image caption.
      # @param message_id [String] The id of the message to reply to.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer,
          video_id: T.nilable(String), link: T.nilable(String), caption: String,
          message_id: T.nilable(String)
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_video(
        sender_id:, recipient_number:, video_id: nil, link: nil, caption: "", message_id: nil
      )
        raise MissingArgumentError, "video_id or link is required" if !video_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "video"
        }
        params[:video] = if link
                           { link: link, caption: caption }
                         else
                           { id: video_id, caption: caption }
                         end
        params[:context] = { message_id: message_id } if message_id

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      # Send a document.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param document_id [String] document ID.
      # @param link [String] Image link.
      # @param caption [String] Image caption.
      # @param message_id [String] The id of the message to reply to.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer,
          document_id: T.nilable(String), link: T.nilable(String), caption: String,
          message_id: T.nilable(String)
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_document(
        sender_id:, recipient_number:, document_id: nil, link: nil, caption: "", message_id: nil
      )
        raise MissingArgumentError, "document or link is required" if !document_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "document"
        }
        params[:document] = if link
                              { link: link, caption: caption }
                            else
                              { id: document_id, caption: caption }
                            end
        params[:context] = { message_id: message_id } if message_id

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      # Send a document.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param sticker_id [String] The sticker ID.
      # @param link [String] Image link.
      # @param message_id [String] The id of the message to reply to.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer, sticker_id: T.nilable(String),
          link: T.nilable(String), message_id: T.nilable(String)
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_sticker(sender_id:, recipient_number:, sticker_id: nil, link: nil, message_id: nil)
        raise MissingArgumentError, "sticker or link is required" if !sticker_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: Resource::Media::Type::Sticker
        }
        params[:sticker] = link ? { link: link } : { id: sticker_id }
        params[:context] = { message_id: message_id } if message_id

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      # Send contacts.
      # You can either send contacts objects or contacts as JSON.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param contacts [Array<Contact>] Contacts.
      # @param contacts_json [Json] Contacts.
      # @param message_id [String] The id of the message to reply to.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer,
          contacts: T.nilable(T::Array[WhatsappSdk::Resource::Contact]),
          contacts_json: T::Hash[T.untyped, T.untyped], message_id: T.nilable(String)
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_contacts(
        sender_id:, recipient_number:, contacts: nil, contacts_json: {}, message_id: nil
      )
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "contacts"
        }
        params[:contacts] = contacts ? contacts.map(&:to_h) : contacts_json
        params[:context] = { message_id: message_id } if message_id

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      # def send_interactive_button
      #   # TODO: https://developers.facebook.com/docs/whatsapp_sdk/cloud-api/reference/messages#contacts-object
      # end

      # def send_interactive_reply_buttons
      #   # TODO: https://developers.facebook.com/docs/whatsapp_sdk/cloud-api/reference/messages#contacts-object
      # end

      # def send_interactive_section
      #   # TODO: https://developers.facebook.com/docs/whatsapp_sdk/cloud-api/reference/messages#contacts-object
      # end

      # Mark a message as read.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param message_id [Integer] Message ID.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig { params(sender_id: Integer, message_id: String).returns(WhatsappSdk::Api::Response) }
      def read_message(sender_id:, message_id:)
        params = {
          messaging_product: "whatsapp",
          status: "read",
          message_id: message_id
        }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::ReadMessageDataResponse
        )
      end

      # Send template
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param name [String] the template's name.
      # @param language [String] template language.
      # @param components [Component] Component.
      # @param components_json [Json] The component as a Json. If you pass components_json, you can't pass components.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer, name: String, language: String,
          components: T.nilable(T::Array[WhatsappSdk::Resource::Component]),
          components_json: T.nilable(T::Array[T::Hash[T.untyped, T.untyped]])
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_template(
        sender_id:, recipient_number:, name:, language:, components: nil, components_json: nil
      )
        raise MissingArgumentError, "components or components_json is required" if !components && !components_json

        params = {
          messaging_product: "whatsapp",
          recipient_type: "individual",
          to: recipient_number,
          type: "template",
          template: {
            name: name
          }
        }

        params[:template][:language] = { code: language } if language
        params[:template][:components] = if components.nil?
                                           components_json
                                         else
                                           components.map(&:to_json)
                                         end

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      # Send reaction
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param message_id [String] the id of the message to reaction.
      # @param emoji [String] unicode of the emoji to send.
      # @return [WhatsappSdk::Api::Response] Response object.
      sig do
        params(
          sender_id: Integer, recipient_number: Integer, message_id: String,
          emoji: T.any(String, Integer)
        ).returns(WhatsappSdk::Api::Response)
      end
      def send_reaction(sender_id:, recipient_number:, message_id:, emoji:)
        params = {
          messaging_product: "whatsapp",
          recipient_type: "individual",
          to: recipient_number,
          type: "reaction",
          reaction: {
            message_id: message_id,
            emoji: emoji
          }
        }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      private

      sig { params(sender_id: Integer).returns(String) }
      def endpoint(sender_id)
        "#{sender_id}/messages"
      end
    end
  end
end
