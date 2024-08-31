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

      class Type < T::Enum
        enums do
          Text = new("text")
          Currency = new("currency")
          DateTime = new("date_time")
          Image = new("image")
          Document = new("document")
          Video = new("video")
          Location = new("location")
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
        @type = deserialize_type(type)
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
        json = { type: type.serialize }
        json[type.serialize.to_sym] = case type.serialize
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

      def deserialize_type(type)
        return type if type.is_a?(Type)

        Type.deserialize(type)
      end

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
          [Type::Text, text],
          [Type::Currency, currency],
          [Type::DateTime, date_time],
          [Type::Image, image],
          [Type::Document, document],
          [Type::Video, video],
          [Type::Location, location]
        ].each do |type_b, value|
          next unless type == type_b

          if value.nil?
            raise Errors::MissingValue.new(type.serialize,
                                           "#{type_b} is required when the type is #{type_b}")
          end
        end
      end
    end
  end
end
