# typed: strict
# frozen_string_literal: true

require "faraday"
require "faraday/multipart"

require_relative "request"
require_relative "response"
require_relative 'responses/media_data_response'
require_relative 'responses/success_response'
require_relative '../resource/media_types'

module WhatsappSdk
  module Api
    class Medias < Request
      class FileNotFoundError < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :file_path

        sig { params(file_path: String).void }
        def initialize(file_path:)
          @file_path = file_path

          message = "Couldn't find file_path: #{file_path}"
          super(message)
        end
      end

      class InvalidMediaTypeError < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :media_type

        sig { params(media_type: String).void }
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
      # @return [Api::Response] Response object.
      sig { params(media_id: String).returns(Api::Response) }
      def media(media_id:)
        response = send_request(
          http_method: "get",
          endpoint: "/#{media_id}"
        )

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::MediaDataResponse
        )
      end

      # Download Media by URL.
      #
      # @param url URL.
      # @param file_path [String] The file_path to download the media e.g. "tmp/downloaded_image.png".
      # @param media_type [String] The media type e.g. "audio/mp4". See possible types in the official
      #  documentation https://developers.facebook.com/docs/whatsapp/cloud-api/reference/media#supported-media-types,
      #  but note that the API may allow more depending on the client.
      # @return [Api::Response] Response object.
      sig { params(url: String, file_path: String, media_type: String).returns(Api::Response) }
      def download(url:, file_path:, media_type:)
        # Allow download of unsupported media types, since Cloud API may decide to let it through.
        #   https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/discussions/127
        # raise InvalidMediaTypeError.new(media_type: media_type) unless valid_media_type?(media_type)

        content_type_header = map_media_type_to_content_type_header(media_type)

        response = download_file(url: url, file_path: file_path, content_type_header: content_type_header)
        response = response
        response = if response["code"].to_i == 200
                     { "success" => true }
                   else
                     { "error" => true, "status" => response["code"] }
                   end

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::SuccessResponse,
          error_class_type: Api::Responses::ErrorResponse
        )
      end

      # Upload a media.
      # @param sender_id [Integer] Sender' phone number.
      # @param file_path [String] Path to the file stored in your local directory. For example: "tmp/whatsapp.png".
      # @param type [String] Media type e.g. text/plain, video/3gp, image/jpeg, image/png. For more information,
      # see the official documentation https://developers.facebook.com/docs/whatsapp/cloud-api/reference/media#supported-media-types.
      #
      # @return [Api::Response] Response object.
      sig { params(sender_id: Integer, file_path: String, type: String).returns(Api::Response) }
      def upload(sender_id:, file_path:, type:)
        raise FileNotFoundError.new(file_path: file_path) unless File.file?(file_path)

        params = {
          messaging_product: "whatsapp",
          file: Faraday::FilePart.new(file_path, type),
          type: type
        }

        response = send_request(http_method: "post", endpoint: "#{sender_id}/media", params: params, multipart: true)

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::MediaDataResponse
        )
      end

      # Delete a Media by ID.
      #
      # @param media_id [String] Media Id.
      # @return [Api::Response] Response object.
      sig { params(media_id: String).returns(Api::Response) }
      def delete(media_id:)
        response = send_request(
          http_method: "delete",
          endpoint: "/#{media_id}"
        )

        Api::Response.new(
          response: response,
          data_class_type: Api::Responses::SuccessResponse
        )
      end

      private

      sig { params(media_type: String).returns(String) }
      def map_media_type_to_content_type_header(media_type)
        # Media type maps 1:1 to the content-type header.
        # The list of supported types are in MediaTypes::SUPPORTED_TYPES.
        # It uses the media type defined by IANA https://www.iana.org/assignments/media-types

        media_type
      end

      sig { params(media_type: String).returns(T::Boolean) }
      def valid_media_type?(media_type)
        Resource::MediaTypes::SUPPORTED_MEDIA_TYPES.include?(media_type)
      end
    end
  end
end
