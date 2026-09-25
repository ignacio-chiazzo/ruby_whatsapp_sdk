# frozen_string_literal: true

require_relative "request"

module WhatsappSdk
  module Api
    class Messages < Request
      DEFAULT_HEADERS = { 'Content-Type' => 'application/json' }.freeze

      # Send a text message.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param message [String] Text to send.
      # @param message_id [String] The id of the message to reply to.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_text(sender_id:, message:, recipient_number: nil, message_id: nil, recipient: nil)
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "text",
          text: { body: message }
        }
        params[:context] = { message_id: message_id } if message_id
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
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
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_location(
        sender_id:, longitude:, latitude:, name:, address:, recipient_number: nil, message_id: nil, recipient: nil
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
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      # Send an image.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param image_id [String] Image ID.
      # @param link [String] Image link.
      # @param caption [String] Image caption.
      # @param message_id [String] The id of the message to reply to.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_image(
        sender_id:, recipient_number: nil, image_id: nil, link: nil, caption: "", message_id: nil, recipient: nil
      )
        raise Resource::Errors::MissingArgumentError, "image_id or link is required" if !image_id && !link

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
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      # Send an audio.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param audio_id [String] Audio ID.
      # @param link [String] Audio link.
      # @param message_id [String] The id of the message to reply to.
      # @param voice [Boolean] Send an Ogg/Opus voice message instead of basic audio. Defaults to false.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_audio(
        sender_id:, recipient_number: nil, audio_id: nil, link: nil, message_id: nil, voice: false, recipient: nil
      )
        raise Resource::Errors::MissingArgumentError, "audio_id or link is required" if !audio_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "audio"
        }
        params[:audio] = link ? { link: link, voice: voice } : { id: audio_id, voice: voice }
        params[:context] = { message_id: message_id } if message_id
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS,
          multipart: true
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      # Send a video.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param video_id [String] Video ID.
      # @param link [String] Image link.
      # @param caption [String] Image caption.
      # @param message_id [String] The id of the message to reply to.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_video(
        sender_id:, recipient_number: nil, video_id: nil, link: nil, caption: "", message_id: nil, recipient: nil
      )
        raise Resource::Errors::MissingArgumentError, "video_id or link is required" if !video_id && !link

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
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      # Send a document.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param document_id [String] document ID.
      # @param link [String] Image link.
      # @param caption [String] Image caption.
      # @param message_id [String] The id of the message to reply to.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_document(
        sender_id:, recipient_number: nil, document_id: nil, link: nil, caption: "", message_id: nil,
        filename: nil, recipient: nil
      )
        if !document_id && !link
          raise Resource::Errors::MissingArgumentError,
                "document or link is required"
        end

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
        params[:document] = params[:document].merge({ filename: filename }) if filename
        params[:context] = { message_id: message_id } if message_id
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      # Send a sticker.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param sticker_id [String] The sticker ID.
      # @param link [String] Image link.
      # @param message_id [String] The id of the message to reply to.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_sticker(sender_id:, recipient_number: nil, sticker_id: nil, link: nil, message_id: nil, recipient: nil)
        raise Resource::Errors::MissingArgumentError, "sticker or link is required" if !sticker_id && !link

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: Resource::Media::Type::STICKER
        }
        params[:sticker] = link ? { link: link } : { id: sticker_id }
        params[:context] = { message_id: message_id } if message_id
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      # Send contacts.
      # You can either send contacts objects or contacts as JSON.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param contacts [Array<Contact>] Contacts.
      # @param contacts_json [Json] Contacts.
      # @param message_id [String] The id of the message to reply to.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_contacts(
        sender_id:, recipient_number: nil, contacts: nil, contacts_json: {}, message_id: nil, recipient: nil
      )
        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "contacts"
        }
        params[:contacts] = contacts ? contacts.map(&:to_h) : contacts_json
        params[:context] = { message_id: message_id } if message_id
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      # def send_interactive_button
      #   # TODO: https://developers.facebook.com/docs/whatsapp_sdk/cloud-api/reference/messages#contacts-object
      # end

      # Send interactive reply buttons.
      # https://developers.facebook.com/docs/whatsapp/guides/interactive-messages#reply-buttons
      # You can either send interactive object or as JSON.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param interactive [Interactive] Interactive.
      # @param interactive_json [Json] The interactive object as a Json.
      #    If you pass interactive_json, you can't pass interactive.
      # @param message_id [String] The id of the message to reply to.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_interactive_message(
        sender_id:, recipient_number: nil, interactive: nil, interactive_json: nil, message_id: nil, recipient: nil
      )
        if !interactive && !interactive_json
          raise Resource::Errors::MissingArgumentError,
                "interactive or interactive_json is required"
        end

        params = {
          messaging_product: "whatsapp",
          to: recipient_number,
          recipient_type: "individual",
          type: "interactive"
        }

        params[:interactive] = if interactive.nil?
                                 interactive_json
                               else
                                 interactive.to_json
                               end
        params[:context] = { message_id: message_id } if message_id
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      alias send_interactive_reply_buttons send_interactive_message
      alias send_interactive_list_messages send_interactive_message

      # Mark a message as read.
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param message_id [Integer] Message ID.
      # @return [Boolean] Whether the message was marked as read.
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

        Api::Responses::SuccessResponse.success_response?(response: response)
      end

      # Send template
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param name [String] the template's name.
      # @param language [String] template language.
      # @param components [Component] Component.
      # @param components_json [Json] The component as a Json. If you pass components_json, you can't pass components.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      #    Not allowed for authentication templates.
      # @return [MessageDataResponse] Response object.
      def send_template(
        sender_id:, name:, language:, recipient_number: nil, components: nil, components_json: nil, recipient: nil
      )
        if !components && !components_json
          raise Resource::Errors::MissingArgumentError,
                "components or components_json is required"
        end

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
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      # Send reaction
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param recipient_number [Integer] Recipient' Phone number.
      # @param message_id [String] the id of the message to reaction.
      # @param emoji [String] unicode of the emoji to send.
      # @param recipient [String] Recipient' Business-Scoped User ID (BSUID). Optional alternative to recipient_number.
      # @return [MessageDataResponse] Response object.
      def send_reaction(sender_id:, message_id:, emoji:, recipient_number: nil, recipient: nil)
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
        apply_recipient!(params, recipient_number, recipient)

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::MessageDataResponse.build_from_response(response: response)
      end

      # Send typing indicator
      #
      # @param sender_id [Integer] Sender' phone number.
      # @param message_id [String] the id of the message received in the messages webhooks.
      # @return [Hash] Response object with success status.
      def send_typing_indicator(sender_id:, message_id:)
        params = {
          messaging_product: "whatsapp",
          recipient_type: "individual",
          status: "read",
          message_id: message_id,
          typing_indicator: {
            type: "text"
          }
        }

        response = send_request(
          endpoint: endpoint(sender_id),
          params: params,
          headers: DEFAULT_HEADERS
        )

        Api::Responses::SuccessResponse.success_response?(response: response)
      end

      private

      def endpoint(sender_id)
        "#{sender_id}/messages"
      end

      # Applies the destination to the payload.
      # - Phone send (recipient_number present): keeps `to`, never adds `recipient` — payload is
      #   identical to the pre-BSUID behavior.
      # - BSUID send (recipient_number absent, recipient present): drops `to` and sets `recipient`
      #   (the field Meta uses to address a Business-Scoped User ID).
      # Requires at least one destination.
      def apply_recipient!(params, recipient_number, recipient)
        if (recipient_number.nil? ? recipient : recipient_number).to_s.strip.empty?
          raise Resource::Errors::MissingArgumentError, "recipient_number or recipient is required"
        end

        params.delete(:to) if recipient_number.nil?
        params[:recipient] = recipient if recipient_number.nil? && recipient
        params
      end
    end
  end
end
