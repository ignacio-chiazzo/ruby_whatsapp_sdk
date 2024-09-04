# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class ParameterObject
      class InvalidType < StandardError
        attr_accessor :message

        def initialize(type)
          @message = "invalid type #{type}. type should be text, currency, date_time, image, document or video"

          super
        end
      end

      # Returns the parameter type.
      #
      # @returns type [String] Valid options are text, currency, date_time, image, document, video.
      attr_accessor :type

      module Type
        TEXT = "text"
        CURRENCY = "currency"
        DATE_TIME = "date_time"
        IMAGE = "image"
        DOCUMENT = "document"
        VIDEO = "video"
        LOCATION = "location"

        TYPES = [
          TEXT,
          CURRENCY,
          DATE_TIME,
          IMAGE,
          DOCUMENT,
          VIDEO,
          LOCATION
        ].freeze

        def self.valid?(type)
          TYPES.include?(type)
        end
      end

      # Returns Text string if the parameter object type is text.
      # For the header component, the character limit is 60 characters.
      # For the body component, the character limit is 1024 characters.
      #
      # @returns text [String]
      attr_accessor :text

      # Returns Currency if the parameter object type is currency.
      #
      # @returns currency [Currency]
      attr_accessor :currency

      # Returns date_time if the parameter object type is date_time.
      #
      # @returns date_time [DateTime]
      attr_accessor :date_time

      # Returns image if the parameter object type is image.
      #
      # @returns image [Media]
      attr_accessor :image

      # Returns document if the parameter object type is document.
      #
      # @returns document [Media]
      attr_accessor :document

      # Returns video if the parameter object type is video.
      #
      # @returns video [Media]
      attr_accessor :video

      # Returns location if the parameter object type is location
      #
      # @returns location [Location]
      attr_accessor :location

      def initialize(
        type:,
        text: nil,
        currency: nil,
        date_time: nil,
        image: nil,
        document: nil,
        video: nil,
        location: nil
      )
        @type = type
        @text = text
        @currency = currency
        @date_time = date_time
        @image = image
        @document = document
        @video = video
        @location = location
        validate
      end

      def to_json
        json = { type: type }
        json[type.to_sym] = case type
                            when "text"
                              text
                            when "currency"
                              currency.to_json
                            when "date_time"
                              date_time.to_json
                            when "image"
                              image.to_json
                            when "document"
                              document.to_json
                            when "video"
                              video.to_json
                            when "location"
                              location.to_json
                            else
                              raise "Invalid type: #{type}"
                            end

        json
      end

      private

      def validate
        validate_attributes
        validate_type
      end

      def validate_type
        return if Type.valid?(type)

        raise InvalidType, type
      end

      def validate_attributes
        [
          [Type::TEXT, text],
          [Type::CURRENCY, currency],
          [Type::DATE_TIME, date_time],
          [Type::IMAGE, image],
          [Type::DOCUMENT, document],
          [Type::VIDEO, video],
          [Type::LOCATION, location]
        ].each do |type_b, value|
          next unless type == type_b
          next unless value.nil?

          raise Errors::MissingValue.new(
            type,
            "#{type_b} is required when the type is #{type_b}"
          )
        end
      end
    end
  end
end
