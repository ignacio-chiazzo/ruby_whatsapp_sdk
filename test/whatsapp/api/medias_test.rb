# typed: false
# frozen_string_literal: true

require "test_helper"
require 'api/medias'
require 'api/client'

module WhatsappSdk
  module Api
    class MediasTest < Minitest::Test
      include(ErrorsHelper)

      def setup
        client = Client.new(ENV.fetch("WHATSAPP_ACCESS_TOKEN", nil))
        @medias_api = Medias.new(client)
        @sender_id = 107_878_721_936_019
      end

      def test_get_handles_error_response
        VCR.use_cassette("medias/media_handles_error_response") do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @medias_api.get(media_id: "123_123")
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("get", "123_123", "ATf5-CLoxGyJeSu2vrRDOZR", http_error.error_info)
        end
      end

      def test_get_image_with_success_response
        VCR.use_cassette("medias/media_with_success_response") do
          media = @medias_api.get(media_id: "1761991787669262")

          assert_media_response(
            {
              url: "https://lookaside.fbsbx.com/whatsapp_business/attachments/?mid=1761991787669262&ext=1728904986&hash=ATta-PkMyBz0aTF9b0CVDimLtAkAgpdXQa6t5x1KgUOu-Q",
              mime_type: "image/png",
              sha256: "c86c28d437534f7367e73b283155c083dddfdaf7f9b4dfae27e140f880035141",
              file_size: 182_859,
              id: "1761991787669262",
              messaging_product: "whatsapp"
            },
            media
          )
        end
      end

      def test_get_video_with_success_response
        VCR.use_cassette("medias/test_get_video_with_success_response") do
          media = @medias_api.get(media_id: "396305933546205")

          assert_media_response(
            {
              url: "https://lookaside.fbsbx.com/whatsapp_business/attachments/?mid=396305933546205&ext=1729032963&hash=ATvggxtHdMmiuPe54wrgdkwLlJlD_Ya2ByuYUU9_PYE7ZA",
              mime_type: "application/pdf",
              sha256: "9c0ec015ef2ec004c152dfa72cd07929f9fcb775d8d38aa1e9bf216ecfc003d7",
              file_size: 14_254,
              id: "396305933546205",
              messaging_product: "whatsapp"
            },
            media
          )
        end
      end

      def test_delete_media_handles_error_response
        VCR.use_cassette("medias/delete_media_handles_error_response") do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @medias_api.delete(media_id: "123_123")
          end

          assert_equal(400, http_error.http_status)
          assert_error_info(
            {
              code: 100,
              error_subcode: nil,
              type: "OAuthException",
              message: "(#100) Invalid post_id parameter",
              fbtrace_id: "AIejXf67At-GZg4mX_Cs-Md"
            },
            http_error.error_info
          )
        end
      end

      def test_delete_media_with_success_response
        VCR.use_cassette("medias/delete_media_with_success_response") do
          assert(@medias_api.delete(media_id: "1953032278471180"))
        end
      end

      def test_delete_media_sends_valid_params
        @medias_api.expects(:send_request).with(
          http_method: "delete",
          endpoint: "/1"
        ).returns({ "success" => true })

        assert(@medias_api.delete(media_id: "1"))
      end

      def test_upload_media_raises_an_error_if_the_file_passed_does_not_exists
        error = assert_raises(Medias::FileNotFoundError) do
          @medias_api.upload(sender_id: 123, file_path: "fo.png", type: "image/png")
        end

        assert_equal("Couldn't find file_path: fo.png", error.message)
        assert_equal("fo.png", error.file_path)
      end

      def test_upload_media_handles_error_response
        VCR.use_cassette("medias/upload_media_handles_error_response") do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @medias_api.upload(sender_id: "1234567", file_path: "test/fixtures/assets/whatsapp.png",
                               type: "image/png")
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("post", "1234567", "AntlLyAlE6ZvA8AWFzcRYzZ", http_error.error_info)
        end
      end

      def test_upload_image_media_with_success_response
        VCR.use_cassette("medias/upload_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/whatsapp.png",
                                        type: "image/png")

          assert_equal(Api::Responses::IdResponse, response.class)
          assert_equal("3281363908663165", response.id)
        end
      end

      def test_upload_audio_media_with_success_response
        VCR.use_cassette("medias/upload_audio_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/downloaded_audio.ogg",
                                        type: "audio/ogg")

          assert_equal(Api::Responses::IdResponse, response.class)
          assert_equal("914268667232441", response.id)
        end
      end

      def test_upload_video_media_with_success_response
        VCR.use_cassette("medias/upload_video_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/riquelme.mp4",
                                        type: "video/mp4")

          assert_equal(Api::Responses::IdResponse, response.class)
          assert_equal("1236350287490060", response.id)
        end
      end

      def test_upload_document_media_with_success_response
        VCR.use_cassette("medias/upload_document_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/document.pdf",
                                        type: "application/pdf")

          assert_equal(Api::Responses::IdResponse, response.class)
          assert_equal("347507378388855", response.id)
        end
      end

      def test_upload_sticker_media_with_success_response
        VCR.use_cassette("medias/upload_sticker_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/sticker.webp",
                                        type: "image/webp")

          assert_equal(Api::Responses::IdResponse, response.class)
          assert_equal("503335829198997", response.id)
        end
      end

      def test_upload_media_sends_valid_params
        media_id = "987654321"
        file_path = "test/fixtures/assets/whatsapp.png"
        type = "image/png"

        file_part = mock
        Faraday::FilePart.stubs(:new).returns(file_part)

        custom_headers = {
          "Cache-Control" => "no-cache",
          "Last-Modified" => "Wed, 21 Oct 2015 07:28:00 GMT",
          "E-tag" => "33a64df551425fcc55e4d42a148795d9f25f89d4"
        }

        @medias_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "123/media",
          multipart: true,
          params: {
            messaging_product: "whatsapp",
            file: file_part,
            type: type
          },
          headers: custom_headers
        ).returns({ "id" => media_id })

        response = @medias_api.upload(sender_id: 123, file_path: file_path, type: type, headers: custom_headers)

        assert_equal(Api::Responses::IdResponse, response.class)
        assert_equal(media_id, response.id)
      end

      def test_download_media_handles_error_response
        VCR.use_cassette("medias/download_media_handles_error_response") do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @medias_api.download(url: url_example, media_type: "image/png",
                                 file_path: "test/fixtures/assets/testing.png")
          end

          assert_equal("301", http_error.http_status)
          assert_equal("Redirecting to https://ignaciochiazzo.com/", http_error.body["message"])
        end
      end

      def test_download_media_sends_valid_params
        file_path = "test/fixtures/assets/testing.png"
        @medias_api.expects(:download_file)
                   .with(url: url_example, content_type_header: "image/png", file_path: file_path)
                   .returns(Net::HTTPOK.new(true, 200, "OK"))

        assert(
          @medias_api.download(url: url_example, file_path: file_path, media_type: "image/png")
        )
      end

      def test_download_allows_unsupported_media_type
        unsupported_media_type = "application/x-zip-compressed"
        file_path = "test/fixtures/assets/testing.zip"

        mock = Net::HTTPOK.new(true, 200, "OK")
        mock.instance_variable_set(:@body, { "success" => true }.to_json)

        @medias_api.expects(:download_file)
                   .with(url: url_example, content_type_header: unsupported_media_type, file_path: file_path)
                   .returns(mock)

        assert(
          @medias_api.download(url: url_example, file_path: file_path, media_type: unsupported_media_type)
        )
      end

      def test_download_media_success_response
        VCR.use_cassette("medias/download_media_success_response") do
          url = "https://lookaside.fbsbx.com/whatsapp_business/attachments/?mid=1761991787669262&ext=1728905510&hash=ATsz9FvlFt63X6Vj00u7PY7SNVCDtCYDeyUqClaX8b5rAg"
          assert(
            @medias_api.download(
              url: url, file_path: "test/fixtures/assets/testing.png", media_type: "image/png"
            )
          )
        end
      end

      private

      def url_example
        "https://www.ignaciochiazzo.com"
      end

      def assert_media_response(expected_media_response, media)
        assert_equal(WhatsappSdk::Resource::Media, media.class)
        assert_equal(expected_media_response[:id], media.id)
        assert_equal(expected_media_response[:url], media.url)
        assert_equal(expected_media_response[:mime_type], media.mime_type)
        assert_equal(expected_media_response[:sha256], media.sha256)
        assert_equal(expected_media_response[:file_size], media.file_size)
        assert_equal(expected_media_response[:messaging_product], media.messaging_product)
      end
    end
  end
end
