# frozen_string_literal: true

require "faraday"
require "faraday/multipart"

require_relative "request"
require_relative '../resource/media_types'

module WhatsappSdk
  module Api
    class Medias < Request
      class FileNotFoundError < StandardError
        attr_reader :file_path

        def initialize(file_path:)
          @file_path = file_path

          message = "Couldn't find file_path: #{file_path}"
          super(message)
        end
      end

      class InvalidMediaTypeError < StandardError
        attr_reader :media_type

        def initialize(media_type:)
          @media_type = media_type
          message =  "Invalid Media Type #{media_type}. See the supported types in the official documentation " \
                     "https://developers.facebook.com/docs/whatsapp/cloud-api/reference/media#supported-media-types."
          super(message)
        end
      end

      # Get Media by ID.
      #
      # @param media_id [String] Media Id.
      # @return [Resource::Media] Media object.
      def get(media_id:)
        response = send_request(
          http_method: "get",
          endpoint: "/#{media_id}"
        )

        Resource::Media.from_hash(response)
      end

      def media(media_id:)
        warn "[DEPRECATION] `media` is deprecated. Please use `get` instead."
        get(media_id: media_id)
      end

      # Download Media by URL.
      #
      # @param url URL.
      # @param file_path [String] The file_path to download the media e.g. "tmp/downloaded_image.png".
      # @param media_type [String] The media type e.g. "audio/mp4". See possible types in the official
      #  documentation https://developers.facebook.com/docs/whatsapp/cloud-api/reference/media#supported-media-types,
      #  but note that the API may allow more depending on the client.
      # @return [Boolean] Whether the media was downloaded successfully.
      def download(url:, file_path:, media_type:)
        # Allow download of unsupported media types, since Cloud API may decide to let it through.
        #   https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/discussions/127
        # raise InvalidMediaTypeError.new(media_type: media_type) unless valid_media_type?(media_type)

        content_type_header = map_media_type_to_content_type_header(media_type)

        response = download_file(url: url, file_path: file_path, content_type_header: content_type_header)

        return true if response.code.to_i == 200

        begin
          body = JSON.parse(response.body)
        rescue JSON::ParserError
          body = { "message" => response.body }
        end

        raise Api::Responses::HttpResponseError.new(http_status: response.code, body: body)
      end

      # Upload a media.
      # @param sender_id [Integer] Sender' phone number.
      # @param file_path [String] Path to the file stored in your local directory. For example: "tmp/whatsapp.png".
      # @param type [String] Media type e.g. text/plain, video/3gp, image/jpeg, image/png. For more information,
      # see the official documentation https://developers.facebook.com/docs/whatsapp/cloud-api/reference/media#supported-media-types.
      #
      # @return [Api::Responses::IdResponse] IdResponse object.
      def upload(sender_id:, file_path:, type:, headers: {})
        raise FileNotFoundError.new(file_path: file_path) unless File.file?(file_path)

        params = {
          messaging_product: "whatsapp",
          file: Faraday::FilePart.new(file_path, type),
          type: type
        }

        response = send_request(
          http_method: "post",
          endpoint: "#{sender_id}/media",
          params: params,
          headers: headers,
          multipart: true
        )

        Api::Responses::IdResponse.new(response["id"])
      end

      # Delete a Media by ID.
      #
      # @param media_id [String] Media Id.
      # @return [Boolean] Whether the media was deleted successfully.
      def delete(media_id:)
        response = send_request(
          http_method: "delete",
          endpoint: "/#{media_id}"
        )

        Api::Responses::SuccessResponse.success_response?(response: response)
      end

      # Create a Graph upload session for template media or a business profile photo.
      # Returns the raw response containing the upload session "id".
      # Uses the client's API version and token unless access_token is supplied.
      #
      # @param app_id [String, Integer] Meta app ID that owns the upload session.
      # @param file_path [String] Path to the local file whose name and size are sent.
      # @param type [String] File MIME type, such as image/jpeg.
      # @param access_token [String, nil] Token override; nil uses the client's token.
      # @return [Hash] Raw Graph response containing the upload session "id".
      # @raise [FileNotFoundError] If file_path does not identify a regular file.
      # @raise [Api::Responses::HttpResponseError] If Graph returns an API error or a server error.
      # @raise [SystemCallError] If the file metadata cannot be read.
      def create_upload_session(app_id:, file_path:, type:, access_token: nil)
        raise FileNotFoundError.new(file_path: file_path) unless File.file?(file_path)

        headers = { 'Content-Type' => 'application/json' }
        headers['Authorization'] = "Bearer #{access_token}" if access_token
        send_request(
          endpoint: "./#{app_id}/uploads",
          params: { file_name: File.basename(file_path), file_length: File.size(file_path), file_type: type },
          headers: headers
        )
      end

      # Upload the complete file to a Graph upload session, starting at offset zero.
      # Returns the raw response containing the reusable media handle "h".
      # This does not resume partial uploads or retry failed requests.
      #
      # @param session_id [String] Upload session ID returned by create_upload_session, including any signature.
      # @param file_path [String] Path to the local file to upload in full.
      # @param access_token [String, nil] Token override; nil uses the client's token.
      # @return [Hash] Raw Graph response containing the reusable media handle "h".
      # @raise [FileNotFoundError] If file_path does not identify a regular file.
      # @raise [Api::Responses::HttpResponseError] If Graph returns an API error or a server error.
      # @raise [SystemCallError] If the file cannot be read.
      def upload_file_to_session(session_id:, file_path:, access_token: nil)
        raise FileNotFoundError.new(file_path: file_path) unless File.file?(file_path)

        headers = { 'Content-Type' => 'application/octet-stream', 'file_offset' => '0' }
        headers['Authorization'] = "Bearer #{access_token}" if access_token
        # ponytail: buffers the whole file; stream bytes if large uploads become a requirement.
        send_request(endpoint: "./#{session_id}", params: File.binread(file_path), headers: headers)
      end

      private

      def map_media_type_to_content_type_header(media_type)
        # Media type maps 1:1 to the content-type header.
        # The list of supported types are in MediaTypes::SUPPORTED_TYPES.
        # It uses the media type defined by IANA https://www.iana.org/assignments/media-types

        media_type
      end

      def valid_media_type?(media_type)
        Resource::MediaTypes::SUPPORTED_MEDIA_TYPES.include?(media_type)
      end
    end
  end
end
