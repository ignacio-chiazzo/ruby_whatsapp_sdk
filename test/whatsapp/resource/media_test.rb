# frozen_string_literal: true
# typed: true

require "test_helper"
require_relative '../../../lib/whatsapp_sdk/resource/media'

module WhatsappSdk
  module Resource
    module Resource
      class MediaTest < Minitest::Test
        def test_raise_an_error_when_filename_is_passed_and_type_is_not_document
          error = assert_raises(WhatsappSdk::Resource::Media::InvalidMedia) do
            WhatsappSdk::Resource::Media.new(
              type: WhatsappSdk::Resource::Media::Type::Sticker,
              filename: "afs"
            )
          end

          assert_equal(:filename, error.field)
          assert_equal("filename can only be used with document", error.message)
        end

        def test_raise_an_error_when_caption_is_passed_and_type_is_not_document_nor_image
          error = assert_raises(WhatsappSdk::Resource::Media::InvalidMedia) do
            WhatsappSdk::Resource::Media.new(
              type: WhatsappSdk::Resource::Media::Type::Video,
              caption: "I am a caption"
            )
          end

          assert_equal(:caption, error.field)
          assert_equal("caption can only be used with document or image", error.message)
        end

        def test_to_json
          image = WhatsappSdk::Resource::Media.new(type: WhatsappSdk::Resource::Media::Type::Image,
                                                   link: "http(s)://URL", caption: "caption")
          document = WhatsappSdk::Resource::Media.new(type: WhatsappSdk::Resource::Media::Type::Document,
                                                      link: "http(s)://URL", filename: "txt.rb")
          video = WhatsappSdk::Resource::Media.new(type: WhatsappSdk::Resource::Media::Type::Video, id: "123")
          audio = WhatsappSdk::Resource::Media.new(type: WhatsappSdk::Resource::Media::Type::Audio, id: "456")
          sticker = WhatsappSdk::Resource::Media.new(type: WhatsappSdk::Resource::Media::Type::Sticker, id: "789")

          assert_equal({ link: "http(s)://URL", caption: "caption" }, image.to_json)
          assert_equal({ link: "http(s)://URL", filename: "txt.rb" }, document.to_json)
          assert_equal({ id: "123" }, video.to_json)
          assert_equal({ id: "456" }, audio.to_json)
          assert_equal({ id: "789" }, sticker.to_json)
        end
      end
    end
  end
end
