# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveHeader
      # Returns the interactive header type.
      #
      # @returns type [String] Valid options are text, image, document, video.
      attr_accessor :type

      module Type
        TEXT = "text"
        IMAGE = "image"
        DOCUMENT = "document"
        VIDEO = "video"
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
        @type = type
        @text = text
        @image = image
        @document = document
        @video = video
        validate
      end

      def to_json
        json = { type: type }
        json[type.to_sym] = case type
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

      def validate
        validate_attributes
      end

      def validate_attributes
        [
          [Type::TEXT, text],
          [Type::IMAGE, image],
          [Type::DOCUMENT, document],
          [Type::VIDEO, video]
        ].each do |type_b, value|
          next unless type == type_b

          next unless value.nil?

          raise Resource::Errors::MissingValue.new(
            type,
            "#{type} is required when the type is #{type_b}"
          )
        end
      end
    end
  end
end
