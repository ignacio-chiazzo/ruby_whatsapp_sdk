# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Media
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

        VALID_TYPES = [AUDIO, DOCUMENT, IMAGE, VIDEO, STICKER].freeze
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

      def to_json(*_args)
        json = {}
        json[:id] = id unless id.nil?
        json[:link] = link unless link.nil?
        json[:caption] = caption unless caption.nil?
        json[:filename] = filename unless filename.nil?
        json
      end

      private

      def validate_media
        unless Type::VALID_TYPES.include?(type)
          raise InvalidMedia.new(:type, "invalid type. type should be audio, document, image, video or sticker")
        end
        if filename && (type != Type::DOCUMENT)
          raise InvalidMedia.new(:filename, "filename can only be used with document")
        end

        if caption && !(type == Type::DOCUMENT || type == Type::IMAGE)
          raise InvalidMedia.new(:caption, "caption can only be used with document or image")
        end

        true
      end
    end
  end
end
