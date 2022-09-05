# frozen_string_literal: true
# typed: strict

module WhatsappSdk
  module Resource
    class ParameterObject
      extend T::Sig

      class InvalidType < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_accessor :message

        sig { params(type: String).void }
        def initialize(type)
          @message = T.let(
            "invalid type #{type}. type should be text, currency, date_time, image, document or video",
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

      # Returns the parameter type.
      #
      # @returns type [String] Valid options are text, currency, date_time, image, document, video.
      sig { returns(Type) }
      attr_accessor :type

      class Type < T::Enum
        extend T::Sig

        enums do
          Text = new("text")
          Currency = new("currency")
          DateTime = new("date_time")
          Image = new("image")
          Document = new("document")
          Video = new("video")
        end
      end

      # Returns Text string if the parameter object type is text.
      # For the header component, the character limit is 60 characters.
      # For the body component, the character limit is 1024 characters.
      #
      # @returns text [String]
      sig { returns(T.nilable(String)) }
      attr_accessor :text

      # Returns Currency if the parameter object type is currency.
      #
      # @returns currency [Currency]
      sig { returns(T.nilable(Currency)) }
      attr_accessor :currency

      # Returns date_time if the parameter object type is date_time.
      #
      # @returns date_time [DateTime]
      sig { returns(T.nilable(DateTime)) }
      attr_accessor :date_time

      # Returns image if the parameter object type is image.
      #
      # @returns image [Media]
      sig { returns(T.nilable(Media)) }
      attr_accessor :image

      # Returns document if the parameter object type is document.
      #
      # @returns document [Media]
      sig { returns(T.nilable(Media)) }
      attr_accessor :document

      # Returns video if the parameter object type is video.
      #
      # @returns video [Media]
      sig { returns(T.nilable(Media)) }
      attr_accessor :video

      sig do
        params(
          type: T.any(Type, String), text: T.nilable(String), currency: T.nilable(Currency),
          date_time: T.nilable(DateTime), image: T.nilable(Media), document: T.nilable(Media), video: T.nilable(Media)
        ).void
      end
      def initialize(type:, text: nil, currency: nil, date_time: nil, image: nil, document: nil, video: nil)
        @type = T.let(deserialize_type(type), Type)
        @text = text
        @currency = currency
        @date_time = date_time
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
                                      when "currency"
                                        T.must(currency).to_json
                                      when "date_time"
                                        T.must(date_time).to_json
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
          [Type::Currency, currency],
          [Type::DateTime, date_time],
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
