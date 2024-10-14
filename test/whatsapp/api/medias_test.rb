# typed: false
# frozen_string_literal: true

require "test_helper"
require 'api/medias'
require 'api/client'

module WhatsappSdk
  module Api
    class MediasTest < Minitest::Test
      include(ErrorsHelper)
      include(ApiResponseHelper)

      def setup
        client = Client.new(ENV["WHATSAPP_ACCESS_TOKEN"])
        @medias_api = Medias.new(client)
        @sender_id = 107_878_721_936_019
      end

      def test_media_handles_error_response
        VCR.use_cassette("medias/media_handles_error_response") do
          response = @medias_api.media(media_id: "123_123")
          assert_unsupported_request_error("get", response, "123_123", "ATf5-CLoxGyJeSu2vrRDOZR")
        end
      end

      def test_media_with_success_response
        VCR.use_cassette("medias/media_with_success_response") do
          response = @medias_api.media(media_id: "1761991787669262")

          assert_media_response({
            url: "https://lookaside.fbsbx.com/whatsapp_business/attachments/?mid=1761991787669262&ext=1728904986&hash=ATta-PkMyBz0aTF9b0CVDimLtAkAgpdXQa6t5x1KgUOu-Q",
            mime_type: "image/png",
            sha256: "c86c28d437534f7367e73b283155c083dddfdaf7f9b4dfae27e140f880035141",
            file_size: 182859,
            id: "1761991787669262",
            messaging_product: "whatsapp"
          }, response)
        end
      end

      def test_media_sends_valid_params
        @medias_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "/1"
        ).returns(valid_media_response)

        response = @medias_api.media(media_id: "1")
        assert_predicate(response, :ok?)
      end

      def test_delete_media_handles_error_response
        VCR.use_cassette("medias/delete_media_handles_error_response") do
          response = @medias_api.delete(media_id: "123_123")
          assert_error_response(
            {
              message: "(#100) Invalid post_id parameter",
              type: "OAuthException",
              code: 100,
              fbtrace_id: "AIejXf67At-GZg4mX_Cs-Md"
            },
            response
          )
        end
      end

      def test_delete_media_with_success_response
        VCR.use_cassette("medias/delete_media_with_success_response") do
          response = @medias_api.delete(media_id: "1953032278471180")

          assert_ok_success_response(response)
        end
      end

      def test_delete_media_sends_valid_params
        @medias_api.expects(:send_request).with(
          http_method: "delete",
          endpoint: "/1"
        ).returns({ "success" => true })

        response = @medias_api.delete(media_id: "1")
        assert_ok_success_response(response)
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
          response = @medias_api.upload(sender_id: "1234567", file_path: "test/fixtures/assets/whatsapp.png", type: "image/png")

          assert_unsupported_request_error("post", response, "1234567", "AntlLyAlE6ZvA8AWFzcRYzZ")
        end
      end

      def test_upload_image_media_with_success_response
        VCR.use_cassette("medias/upload_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/whatsapp.png", type: "image/png")

          assert_ok_response(response)
          assert_equal(Responses::MediaDataResponse, response.data.class)
          assert_equal("3281363908663165", response.data.id)
        end
      end

      def test_upload_audio_media_with_success_response
        VCR.use_cassette("medias/upload_audio_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/downloaded_audio.ogg", type: "audio/ogg")

          assert_ok_response(response)
          assert_equal(Responses::MediaDataResponse, response.data.class)
          assert_equal("914268667232441", response.data.id)
        end
      end

      def test_upload_video_media_with_success_response
        VCR.use_cassette("medias/upload_video_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/riquelme.mp4", type: "video/mp4")

          assert_ok_response(response)
          assert_equal(Responses::MediaDataResponse, response.data.class)
          assert_equal("1236350287490060", response.data.id)
        end
      end

      def test_upload_document_media_with_success_response
        VCR.use_cassette("medias/upload_document_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/document.pdf", type: "application/pdf")

          assert_ok_response(response)
          assert_equal(Responses::MediaDataResponse, response.data.class)
          assert_equal("347507378388855", response.data.id)
        end
      end

      def test_upload_sticker_media_with_success_response
        VCR.use_cassette("medias/upload_sticker_media_with_success_response") do
          response = @medias_api.upload(sender_id: @sender_id, file_path: "test/fixtures/assets/sticker.webp", type: "image/webp")

          assert_ok_response(response)
          assert_equal(Responses::MediaDataResponse, response.data.class)
          assert_equal("503335829198997", response.data.id)
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

        assert_ok_response(response)
        assert_equal(Responses::MediaDataResponse, response.data.class)
        assert_equal(media_id, response.data.id)
      end

      def test_download_media_handles_error_response
        VCR.use_cassette("medias/download_media_handles_error_response") do
          response = @medias_api.download(url: url_example, media_type: "image/png", file_path: "test/fixtures/assets/testing.png")

          assert_predicate(response, :error?)
          assert_equal(Responses::ErrorResponse, response.error.class)
          assert_equal("301", response.error.status)
        end
      end

      def test_download_media_sends_valid_params
        file_path = "test/fixtures/assets/testing.png"
        @medias_api.expects(:download_file)
                   .with(url: url_example, content_type_header: "image/png", file_path: file_path)
                   .returns(Net::HTTPOK.new(true, 200, "OK"))

        response = @medias_api.download(url: url_example, file_path: file_path, media_type: "image/png")
        assert_ok_success_response(response)
      end

      def test_download_allows_unsupported_media_type
        unsupported_media_type = "application/x-zip-compressed"
        file_path = "test/fixtures/assets/testing.zip"
        @medias_api.expects(:download_file).with(url: url_example, content_type_header: unsupported_media_type,
                                                 file_path: file_path)
                   .returns(Net::HTTPOK.new(true, 200, "OK"))
        response = @medias_api.download(url: url_example, file_path: file_path, media_type: unsupported_media_type)
        assert_ok_success_response(response)
      end

      def test_download_media_success_response
        VCR.use_cassette("medias/download_media_success_response") do
          url = "https://lookaside.fbsbx.com/whatsapp_business/attachments/?mid=1761991787669262&ext=1728905510&hash=ATsz9FvlFt63X6Vj00u7PY7SNVCDtCYDeyUqClaX8b5rAg"
          response = @medias_api.download(url: url, file_path: "test/fixtures/assets/testing.png", media_type: "image/png")
          assert_ok_success_response(response)
        end
      end

      private

      def url_example
        "https://www.ignaciochiazzo.com"
      end

      def assert_ok_response(response)
        assert_equal(Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
      end

      def valid_media_response
        {
          "url" => "www.ignaciochiazzo.com",
          "mime_type" => "image/jpeg",
          "sha256" => "821858a6a2f4fb2f0860f646924321dfbcd34d1af2a692e5aeec0b4bd2219ade",
          "file_size" => 1170,
          "id" => "123456",
          "messaging_product" => "whatsapp"
        }
      end

      def assert_media_response(expected_media_response, response)
        assert_ok_response(response)

        assert_equal(Responses::MediaDataResponse, response.data.class)
        assert_equal(expected_media_response[:id], response.data.id)
        assert_equal(expected_media_response[:url], response.data.url)
        assert_equal(expected_media_response[:mime_type], response.data.mime_type)
        assert_equal(expected_media_response[:sha256], response.data.sha256)
        assert_equal(expected_media_response[:file_size], response.data.file_size)
        assert_equal(expected_media_response[:messaging_product], response.data.messaging_product)
      end
    end
  end
end
