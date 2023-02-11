# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Media
      extend T::Sig

      class InvalidMedia < StandardError
        extend T::Sig

        sig { returns(Symbol) }
        attr_reader :field

        sig { returns(String) }
        attr_reader :message

        sig { params(field: Symbol, message: String).void }
        def initialize(field, message)
          @field = field
          @message = message
          super(message)
        end
      end

      # Returns media id.
      #
      # @returns id [String].
      sig { returns(T.nilable(String)) }
      attr_accessor :id

      class Type < T::Enum
        extend T::Sig

        enums do
          Audio = new('audio')
          Document = new('document')
          Image = new('image')
          Video = new('video')
          Sticker = new('sticker')
        end
      end

      # @returns type [String]. Valid options ar audio, document, image, video and sticker.
      sig { returns(Type) }
      attr_accessor :type

      # The protocol and URL of the media to be sent. Use only with HTTP/HTTPS URLs.
      # Do not use this field when the message type is set to text.
      #
      # @returns link [String].
      sig { returns(T.nilable(String)) }
      attr_accessor :link

      # Describes the specified document or image media.
      #
      # @returns caption [String].
      sig { returns(T.nilable(String)) }
      attr_accessor :caption

      # Describes the filename for the specific document. Use only with document media.
      #
      # @returns filename [String].
      sig { returns(T.nilable(String)) }
      attr_accessor :filename

      sig do
        params(
          type: T.any(Type, String), id: T.nilable(String), link: T.nilable(String),
          caption: T.nilable(String), filename: T.nilable(String)
        ).void
      end
      def initialize(type:, id: nil, link: nil, caption: nil, filename: nil)
        @type = T.let(deserialize_type(type), Type)
        @id = id
        @link = link
        @caption = caption
        @filename = filename
        validate_media
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_json
        json = {}
        json[:id] = id unless id.nil?
        json[:link] = link unless link.nil?
        json[:caption] = caption unless caption.nil?
        json[:filename] = filename unless filename.nil?
        json
      end

      private

      sig { params(type: T.any(String, Type)).returns(Type) }
      def deserialize_type(type)
        return type if type.is_a?(Type)

        Type.deserialize(type)
      end

      sig { returns(T::Boolean) }
      def validate_media
        if filename && (type != Type::Document)
          raise InvalidMedia.new(:filename, "filename can only be used with document")
        end

        if caption && !(type == Type::Document || type == Type::Image)
          raise InvalidMedia.new(:caption, "caption can only be used with document or image")
        end

        true
      end
    end
  end
end
