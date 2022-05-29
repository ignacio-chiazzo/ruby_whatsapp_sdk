# frozen_string_literal: true

require_relative "request"
require_relative "response"

module Whatsapp
  module Api
    class Messages < Request
      class MissingArgumentError < StandardError
        attr_reader :message

        def initialize(message)
          @message = message
          super(message)
        end
      end

      def send_text(sender_id:, recipient_number:, message:)
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
          type: "text",
          "text": { body: message }
        }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::Responses::MessageDataResponse)
      end

      def send_location(sender_id:, recipient_number:, longitude:, latitude:, name:, address:)
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
          type: "location",
          "location": {
            "longitude": longitude,
            "latitude": latitude,
            "name": name,
            "address": address
          }
        }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::Responses::MessageDataResponse)
      end

      def send_image(sender_id:, recipient_number:, image_id: nil, link: nil, caption: "")
        raise MissingArgumentError, "image_id or link is required" if !image_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
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

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::Responses::MessageDataResponse)
      end

      def send_audio(sender_id:, recipient_number:, audio_id: nil, link: nil)
        raise MissingArgumentError, "audio_id or link is required" if !audio_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
          type: "audio"
        }
        params[:audio] = link ? { link: link } : { id: audio_id }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::Responses::MessageDataResponse)
      end

      def send_video(sender_id:, recipient_number:, video_id: nil, link: nil, caption: "")
        raise MissingArgumentError, "video_id or link is required" if !video_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
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

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::Responses::MessageDataResponse)
      end

      def send_document(sender_id:, recipient_number:, document_id: nil, link: nil, caption: "")
        raise MissingArgumentError, "document or link is required" if !document_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
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

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::Responses::MessageDataResponse)
      end

      def send_sticker(sender_id:, recipient_number:, sticker_id: nil, link: nil)
        raise MissingArgumentError, "sticker or link is required" if !sticker_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
          type: "sticker"
        }
        params[:sticker] = link ? { link: link } : { id: sticker_id }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::Responses::MessageDataResponse)
      end

      def send_contacts(sender_id:, recipient_number:, contacts: nil, contacts_json: {})
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
          type: "contacts"
        }
        params[:contacts] = contacts ? contacts.map(&:to_h) : contacts_json

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )

        Whatsapp::Api::Response.new(response: response, class_type: Whatsapp::Api::Responses::MessageDataResponse)
      end

      def send_interactive_button
        # TODO: https://developers.facebook.com/docs/whatsapp/cloud-api/reference/messages#contacts-object
      end

      def send_interactive_reply_buttons
        # TODO: https://developers.facebook.com/docs/whatsapp/cloud-api/reference/messages#contacts-object
      end

      def send_interactive_section
        # TODO: https://developers.facebook.com/docs/whatsapp/cloud-api/reference/messages#contacts-object
      end

      private

      def endpoint(sender_id)
        "#{sender_id}/messages"
      end
    end
  end
end
