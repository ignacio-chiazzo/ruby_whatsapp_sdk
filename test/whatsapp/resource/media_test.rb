# typed: true
# frozen_string_literal: true

require "test_helper"
require 'resource/media'

module WhatsappSdk
  module Resource
    module Resource
      class MediaTest < Minitest::Test
        def test_raise_an_error_when_filename_is_passed_and_type_is_not_document
          error = assert_raises(Media::InvalidMedia) do
            Media.new(type: Media::Type::STICKER, filename: "afs")
          end

          assert_equal(:filename, error.field)
          assert_equal("filename can only be used with document", error.message)
        end

        def test_raise_an_error_when_caption_is_passed_and_type_is_not_document_nor_image
          error = assert_raises(Media::InvalidMedia) do
            Media.new(type: Media::Type::VIDEO, caption: "I am a caption")
          end

          assert_equal(:caption, error.field)
          assert_equal("caption can only be used with document or image", error.message)
        end

        def test_to_json
          image = Media.new(type: Media::Type::IMAGE, link: "http(s)://URL", caption: "caption")
          document = Media.new(type: Media::Type::DOCUMENT, link: "http(s)://URL", filename: "txt.rb")
          video = Media.new(type: Media::Type::VIDEO, id: "123")
          audio = Media.new(type: Media::Type::AUDIO, id: "456")
          sticker = Media.new(type: Media::Type::STICKER, id: "789")

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
