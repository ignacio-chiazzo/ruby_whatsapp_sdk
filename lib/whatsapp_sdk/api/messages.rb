# frozen_string_literal: true

require_relative "request"
require_relative "response"

module WhatsappSdk
  module Api
    class Messages < Request
      class MissingArgumentError < StandardError
        attr_reader :message

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
      # @return [WhatsappSdk::Api::Response] Response object.
      def send_text(sender_id:, recipient_number:, message:)
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "text",
          text: { body: message }
        }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
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
      # @return [WhatsappSdk::Api::Response] Response object.
      def send_location(sender_id:, recipient_number:, longitude:, latitude:, name:, address:)
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

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
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
      # @param image_id [Integer] Image ID.
      # @param link [String] Image link.
      # @param caption [String] Image caption.
      # @return [WhatsappSdk::Api::Response] Response object.
      def send_image(sender_id:, recipient_number:, image_id: nil, link: nil, caption: "")
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

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
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
      # @param audio_id [Integer] Audio ID.
      # @param link [String] Audio link.
      # @return [WhatsappSdk::Api::Response] Response object.
      def send_audio(sender_id:, recipient_number:, audio_id: nil, link: nil)
        raise MissingArgumentError, "audio_id or link is required" if !audio_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "audio"
        }
        params[:audio] = link ? { link: link } : { id: audio_id }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
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
      # @param video_id [Integer] Video ID.
      # @param link [String] Image link.
      # @param caption [String] Image caption.
      # @return [WhatsappSdk::Api::Response] Response object.
      def send_video(sender_id:, recipient_number:, video_id: nil, link: nil, caption: "")
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

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
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
      # @param document_id [Integer] document ID.
      # @param link [String] Image link.
      # @param caption [String] Image caption.
      # @return [WhatsappSdk::Api::Response] Response object.
      def send_document(sender_id:, recipient_number:, document_id: nil, link: nil, caption: "")
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

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
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
      # @param link [String] Image link.
      # @return [WhatsappSdk::Api::Response] Response object.
      def send_sticker(sender_id:, recipient_number:, sticker_id: nil, link: nil)
        raise MissingArgumentError, "sticker or link is required" if !sticker_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "sticker"
        }
        params[:sticker] = link ? { link: link } : { id: sticker_id }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
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
      # @return [WhatsappSdk::Api::Response] Response object.
      def send_contacts(sender_id:, recipient_number:, contacts: nil, contacts_json: {})
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "contacts"
        }
        params[:contacts] = contacts ? contacts.map(&:to_h) : contacts_json

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      def send_interactive_button
        # TODO: https://developers.facebook.com/docs/whatsapp_sdk/cloud-api/reference/messages#contacts-object
      end

      def send_interactive_reply_buttons
        # TODO: https://developers.facebook.com/docs/whatsapp_sdk/cloud-api/reference/messages#contacts-object
      end

      def send_interactive_section
        # TODO: https://developers.facebook.com/docs/whatsapp_sdk/cloud-api/reference/messages#contacts-object
      end

      # Mark a message as read.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param message_id [Integer] Message ID.
      # @return [WhatsappSdk::Api::Response] Response object.
      def read_message(sender_id:, message_id:)
        params = {
          messaging_product: "whatsapp",
          status: "read",
          message_id: message_id
        }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
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
      def send_template(sender_id:, recipient_number:, name:, language:, components: nil, components_json: nil)
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
          params: params
        )

        WhatsappSdk::Api::Response.new(
          response: response,
          data_class_type: WhatsappSdk::Api::Responses::MessageDataResponse
        )
      end

      private

      def endpoint(sender_id)
        "#{sender_id}/messages"
      end
    end
  end
end
