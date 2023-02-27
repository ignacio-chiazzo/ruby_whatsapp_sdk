# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveHeader
      extend T::Sig

      class InvalidType < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_accessor :message

        sig { params(type: String).void }
        def initialize(type)
          @message = T.let(
            "invalid type #{type}. type should be text, image, document or video",
            String
          )
          super
        end
      end

      class MissingValue < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :field

        sig { returns(String) }
        attr_reader :message

        sig { params(field: String, message: String).void }
        def initialize(field, message)
          @field = field
          @message = message
          super(message)
        end
      end

      # Returns the interactive header type.
      #
      # @returns type [String] Valid options are text, image, document, video.
      sig { returns(Type) }
      attr_accessor :type

      class Type < T::Enum
        extend T::Sig

        enums do
          Text = new("text")
          Image = new("image")
          Document = new("document")
          Video = new("video")
        end
      end

      # Returns Text string if the interactive header type is text.
      # For the header interactive, the character limit is 60 characters.
      # For the body interactive, the character limit is 1024 characters.
      #
      # @returns text [String]
      sig { returns(T.nilable(String)) }
      attr_accessor :text

      # Returns image if the interactive header type is image.
      #
      # @returns image [Media]
      sig { returns(T.nilable(Media)) }
      attr_accessor :image

      # Returns document if the interactive header type is document.
      #
      # @returns document [Media]
      sig { returns(T.nilable(Media)) }
      attr_accessor :document

      # Returns video if the interactive header type is video.
      #
      # @returns video [Media]
      sig { returns(T.nilable(Media)) }
      attr_accessor :video

      sig do
        params(
          type: T.any(Type, String), text: T.nilable(String), image: T.nilable(Media),
          document: T.nilable(Media), video: T.nilable(Media)
        ).void
      end
      def initialize(type:, text: nil, image: nil, document: nil, video: nil)
        @type = T.let(deserialize_type(type), Type)
        @text = text
        @image = image
        @document = document
        @video = video
        validate
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_json
        json = { type: type.serialize }
        json[type.serialize.to_sym] = case type.serialize
                                      when "text"
                                        text
                                      when "image"
                                        T.must(image).to_json
                                      when "document"
                                        T.must(document).to_json
                                      when "video"
                                        T.must(video).to_json
                                      else
                                        raise "Invalid type: #{type}"
                                      end

        json
      end

      private

      sig { params(type: T.any(String, Type)).returns(Type) }
      def deserialize_type(type)
        return type if type.is_a?(Type)

        Type.deserialize(type)
      end

      sig { void }
      def validate
        validate_attributes
        validate_type
      end

      sig { void }
      def validate_type
        return if Type.valid?(type)

        raise InvalidType, type
      end

      sig { void }
      def validate_attributes
        [
          [Type::Text, text],
          [Type::Image, image],
          [Type::Document, document],
          [Type::Video, video]
        ].each do |type_b, value|
          next unless type == type_b
          raise MissingValue.new(type.serialize, "#{type_b} is required when the type is #{type_b}") if value.nil?
        end
      end
    end
  end
end
