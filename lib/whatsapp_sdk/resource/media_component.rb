# frozen_string_literal: true

# The media used by a component (button, header, body, footer) etc.

module WhatsappSdk
  module Resource
    class MediaComponent
      class InvalidMedia < StandardError
        attr_reader :field, :message

        def initialize(field, message)
          @field = field
          @message = message
          super(message)
        end
      end

      # Returns media id.
      #
      # @returns id [String].
      attr_accessor :id

      module Type
        AUDIO = 'audio'
        DOCUMENT = 'document'
        IMAGE = 'image'
        VIDEO = 'video'
        STICKER = 'sticker'
      end

      # @returns type [String]. Valid options ar audio, document, image, video and sticker.
      attr_accessor :type

      # The protocol and URL of the media to be sent. Use only with HTTP/HTTPS URLs.
      # Do not use this field when the message type is set to text.
      #
      # @returns link [String].
      attr_accessor :link

      # Describes the specified document or image media.
      #
      # @returns caption [String].
      attr_accessor :caption

      # Describes the filename for the specific document. Use only with document media.
      #
      # @returns filename [String].
      attr_accessor :filename

      def initialize(type:, id: nil, link: nil, caption: nil, filename: nil)
        @type = type
        @id = id
        @link = link
        @caption = caption
        @filename = filename
        validate_media
      end

      def to_json
        json = {}
        json[:id] = id unless id.nil?
        json[:link] = link unless link.nil?
        json[:caption] = caption unless caption.nil?
        json[:filename] = filename unless filename.nil?
        json
      end

      private

      def validate_media
        raise InvalidMedia.new(:filename, "filename can only be used with document") if filename && !supports_filename?

        if caption && !supports_caption?
          raise InvalidMedia.new(:caption, "caption can only be used with document or image")
        end

        true
      end

      def supports_filename?
        type == Type::DOCUMENT
      end

      def supports_caption?
        type == Type::DOCUMENT || type == Type::IMAGE
      end
    end
  end
end
