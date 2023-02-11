# typed: false
# frozen_string_literal: true

require "test_helper"
require_relative '../../../lib/whatsapp_sdk/resource/parameter_object'
require_relative '../../../lib/whatsapp_sdk/resource/media'
require_relative '../../../lib/whatsapp_sdk/resource/date_time'
require_relative '../../../lib/whatsapp_sdk/resource/currency'

module WhatsappSdk
  module Resource
    module Resource
      class ParameterObjectTest < Minitest::Test
        def setup
          @image_media = WhatsappSdk::Resource::Media.new(type: WhatsappSdk::Resource::Media::Type::Image,
                                                          link: "http(s)://URL", caption: "caption")
          @document_media = WhatsappSdk::Resource::Media.new(type: WhatsappSdk::Resource::Media::Type::Document,
                                                             link: "http://URL", filename: "txt.rb")
          @video_media = WhatsappSdk::Resource::Media.new(type: WhatsappSdk::Resource::Media::Type::Video, id: "123")
          @currency = WhatsappSdk::Resource::Currency.new(code: "USD", amount: 1000, fallback_value: "USD")
          @date_time = WhatsappSdk::Resource::DateTime.new(fallback_value: "2020-01-01T00:00:00Z")
        end

        [
          ParameterObject::Type::Text, ParameterObject::Type::Currency, ParameterObject::Type::DateTime,
          ParameterObject::Type::Image, ParameterObject::Type::Document, ParameterObject::Type::Video
        ].each do |type|
          define_method(
            "test_raise_an_error_when_type_is_#{type.serialize}_but_the_attribute_#{type.serialize}_is_not_passed"
          ) do
            if type == ParameterObject::Type::Image
              object = @video_media
              attr_name = :video
            else
              object = @image_media
              attr_name = :image
            end

            error = assert_raises(WhatsappSdk::Resource::ParameterObject::MissingValue) do
              T.unsafe(WhatsappSdk::Resource::ParameterObject).new(type: type, attr_name => object)
            end

            assert_equal(type.serialize, error.field)
            assert_equal("#{type} is required when the type is #{type}", error.message)
          end
        end

        def test_creates_a_valid_parameter_object_with_for_type
          WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Text, text: "foo")
          WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Currency, currency: @currency)
          WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::DateTime, date_time: @date_time)
          WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Image, image: @image_media)
          WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Video, video: @video_media)
          WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Document, document: @document_media)
        end

        def test_to_json
          parameter_image = WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Image,
                                                                       image: @image_media)
          assert_equal(
            { type: "image", image: { link: "http(s)://URL", caption: "caption" } },
            parameter_image.to_json
          )

          parameter_document = WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Document,
                                                                          document: @document_media)
          assert_equal(
            { type: "document", document: { link: "http://URL", filename: "txt.rb" } },
            parameter_document.to_json
          )

          parameter_video = WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Video,
                                                                       video: @video_media)
          assert_equal(
            { type: "video", video: { id: "123" } },
            parameter_video.to_json
          )

          parameter_text = WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Text,
                                                                      text: "I am a text")
          assert_equal(
            { type: "text", text: "I am a text" },
            parameter_text.to_json
          )

          parameter_currency = WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::Currency,
                                                                          currency: @currency)
          assert_equal(
            { type: "currency", currency: { fallback_value: "USD", code: "USD", amount_1000: 1000 } },
            parameter_currency.to_json
          )

          parameter_date_time = WhatsappSdk::Resource::ParameterObject.new(type: ParameterObject::Type::DateTime,
                                                                           date_time: @date_time)
          assert_equal(
            { type: "date_time", date_time: { fallback_value: @date_time.fallback_value } },
            parameter_date_time.to_json
          )
        end
      end
    end
  end
end
