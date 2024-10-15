# typed: true
# frozen_string_literal: true

require "test_helper"
require 'resource/media'

module WhatsappSdk
  module Resource
    module Resource
      class MediaComponentTest < Minitest::Test
        def test_raise_an_error_when_filename_is_passed_and_type_is_not_document
          error = assert_raises(MediaComponent::InvalidMedia) do
            MediaComponent.new(type: MediaComponent::Type::STICKER, filename: "afs")
          end

          assert_equal(:filename, error.field)
          assert_equal("filename can only be used with document", error.message)
        end

        def test_raise_an_error_when_caption_is_passed_and_type_is_not_document_nor_image
          error = assert_raises(MediaComponent::InvalidMedia) do
            MediaComponent.new(type: MediaComponent::Type::VIDEO, caption: "I am a caption")
          end

          assert_equal(:caption, error.field)
          assert_equal("caption can only be used with document or image", error.message)
        end

        def test_to_json
          image = MediaComponent.new(type: MediaComponent::Type::IMAGE, link: "http(s)://URL", caption: "caption")
          document = MediaComponent.new(type: MediaComponent::Type::DOCUMENT, link: "http(s)://URL", filename: "txt.rb")
          video = MediaComponent.new(type: MediaComponent::Type::VIDEO, id: "123")
          audio = MediaComponent.new(type: MediaComponent::Type::AUDIO, id: "456")
          sticker = MediaComponent.new(type: MediaComponent::Type::STICKER, id: "789")

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
