# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveHeader
      # Returns the interactive header type.
      #
      # @returns type [String] Valid options are text, image, document, video.
      attr_accessor :type

      class Type < T::Enum
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
      attr_accessor :text

      # Returns image if the interactive header type is image.
      #
      # @returns image [Media]
      attr_accessor :image

      # Returns document if the interactive header type is document.
      #
      # @returns document [Media]
      attr_accessor :document

      # Returns video if the interactive header type is video.
      #
      # @returns video [Media]
      attr_accessor :video

      def initialize(type:, text: nil, image: nil, document: nil, video: nil)
        @type = deserialize_type(type)
        @text = text
        @image = image
        @document = document
        @video = video
        validate
      end

      def to_json
        json = { type: type.serialize }
        json[type.serialize.to_sym] = case type.serialize
                                      when "text"
                                        text
                                      when "image"
                                        image.to_json
                                      when "document"
                                        document.to_json
                                      when "video"
                                        video.to_json
                                      else
                                        raise "Invalid type: #{type}"
                                      end

        json
      end

      private

      def deserialize_type(type)
        return type if type.is_a?(Type)

        Type.deserialize(type)
      end

      def validate
        validate_attributes
      end

      def validate_attributes
        [
          [Type::Text, text],
          [Type::Image, image],
          [Type::Document, document],
          [Type::Video, video]
        ].each do |type_b, value|
          next unless type == type_b

          next unless value.nil?

          raise Resource::Errors::MissingValue.new(
            type.serialize,
            "#{type.serialize} is required when the type is #{type_b}"
          )
        end
      end
    end
  end
end
