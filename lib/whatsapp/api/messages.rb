require "pry"
require "pry-nav"
require "faraday"
require "oj"

require_relative "request"
require_relative "message_response"

module Whatsapp
  module Api
    class Messages < Request
      def send_text(sender_id:, recipient_number:, message:)
        # TODO handle error

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

        Whatsapp::Api::MessageResponse.new(response)
      end

      def send_location(sender_id:, recipient_number:, longitude:, latitude:, name:, address:)
        # TODO handle error
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

        Whatsapp::Api::MessageResponse.new(response)
      end

      def send_image(sender_id:, recipient_number:, image_id: nil, link: nil, caption: "")
        # TODO validate image_id and link nil
        # TODO handle error
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
          type: "image"
        }
        params[:image] = if(link)
           { link: link, caption: caption }
        else
          { id: image_id, caption: caption }
        end

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )
        
        Whatsapp::Api::MessageResponse.new(response)
      end

      def send_audio(sender_id:, recipient_number:, audio_id: nil, link: nil)
        # TODO validate image_id and link nil
        # TODO handle error
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
        
        Whatsapp::Api::MessageResponse.new(response)
      end

      def send_video(sender_id:, recipient_number:, video_id: nil, link: nil, caption: "")
        # TODO validate video_id and link nil
        # TODO handle error
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
          type: "video"
        }
        params[:video] = if(link)
          { link: link, caption: caption }
        else
          { id: video_id, caption: caption }
        end

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )
        
        Whatsapp::Api::MessageResponse.new(response)
      end

      def send_document(sender_id:, recipient_number:, document_id: nil, link: nil, caption: "")
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
          type: "document"
        }
        params[:document] = if(link)
          { link: link, caption: caption }
        else
          { id: document_id, caption: caption }
        end

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )
        
        Whatsapp::Api::MessageResponse.new(response)
      end

      def send_sticker(sender_id:, recipient_number:, sticker_id: nil, link: nil)
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
        
        Whatsapp::Api::MessageResponse.new(response)
      end

      def send_contacts(sender_id:, recipient_number:, contacts:)
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recepient_type: "individual",
          type: "contacts"
        }
        params[:contacts] = contacts.map(&:to_h)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params
        )
        
        Whatsapp::Api::MessageResponse.new(response)
      end

      def send_interactive_button
        # TODO https://developers.facebook.com/docs/whatsapp/cloud-api/reference/messages#contacts-object
      end
      
      def send_interactive_reply_buttons;
      # TODO https://developers.facebook.com/docs/whatsapp/cloud-api/reference/messages#contacts-object
      end
      
      def send_interactive_section
        # TODO https://developers.facebook.com/docs/whatsapp/cloud-api/reference/messages#contacts-object
      end

      private

      def endpoint(sender_id)
        "#{sender_id}/messages"
      end
    end
  end
end
