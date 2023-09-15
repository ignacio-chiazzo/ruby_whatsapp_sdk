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
        client = WhatsappSdk::Api::Client.new("test_token")
        @medias_api = WhatsappSdk::Api::Medias.new(client)
      end

      def test_media_handles_error_response
        mocked_error_response = mock_error_response
        response = @medias_api.media(media_id: "123_123")
        assert_error_response(mocked_error_response, response)
      end

      def test_media_with_success_response
        mock_get_media_response(valid_media_response)
        response = @medias_api.media(media_id: "123_123")
        assert_medias_mock_response(valid_media_response, response)
        assert_predicate(response, :ok?)
      end

      def test_media_sends_valid_params
        @medias_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "/1"
        ).returns(valid_media_response)

        response = @medias_api.media(media_id: "1")
        assert_medias_mock_response(valid_media_response, response)
        assert_predicate(response, :ok?)
      end

      def test_delete_media_handles_error_response
        mocked_error_response = mock_error_response
        response = @medias_api.delete(media_id: "1")
        assert_error_response(mocked_error_response, response)
      end

      def test_delete_media_with_success_response
        success_response = { "success" => true }
        mock_get_media_response(success_response)
        response = @medias_api.delete(media_id: "123_123")

        validate_sucess_data_response(response)
      end

      def test_delete_media_sends_valid_params
        @medias_api.expects(:send_request).with(
          http_method: "delete",
          endpoint: "/1"
        ).returns({ "success" => true })

        response = @medias_api.delete(media_id: "1")
        validate_sucess_data_response(response)
      end

      def test_upload_media_raises_an_error_if_the_file_passed_does_not_exists
        error = assert_raises(WhatsappSdk::Api::Medias::FileNotFoundError) do
          @medias_api.upload(sender_id: 123, file_path: "fo.png", type: "image/png")
        end

        assert_equal("Couldn't find file_path: fo.png", error.message)
        assert_equal("fo.png", error.file_path)
      end

      def test_upload_media_handles_error_response
        mocked_error_response = mock_error_response
        response = @medias_api.upload(sender_id: 123, file_path: "tmp/whatsapp.png", type: "image/png")
        assert_error_response(mocked_error_response, response)
      end

      def test_upload_media_with_success_response
        media_id = "123456"
        valid_response = { "id" => media_id }
        @medias_api.expects(:send_request).returns(valid_response)
        response = @medias_api.upload(sender_id: 123, file_path: "tmp/whatsapp.png", type: "image/png")

        assert_ok_response(response)
        assert_equal(WhatsappSdk::Api::Responses::MediaDataResponse, response.data.class)
        assert_equal(media_id, response.data.id)
      end

      def test_upload_media_sends_valid_params
        media_id = "987654321"
        file_path = "tmp/whatsapp.png"
        type = "image/png"

        file_part = mock
        T.unsafe(Faraday::FilePart).stubs(:new).returns(file_part)

        @medias_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "123/media",
          params: {
            messaging_product: "whatsapp",
            file: file_part,
            type: type
          }
        ).returns({ "id" => media_id })

        response = @medias_api.upload(sender_id: 123, file_path: file_path, type: type)
        assert_ok_response(response)

        assert_equal(WhatsappSdk::Api::Responses::MediaDataResponse, response.data.class)
        assert_equal(media_id, response.data.id)
      end

      def test_download_media_handles_error_response
        @medias_api.stubs(:download_file).returns(Net::HTTPNotFound.new(1, 404, "Not Found"))
        response = @medias_api.download(url: url_example, media_type: "image/png", file_path: "tmp/testing.png")
        refute_predicate(response, :ok?)
        assert_predicate(response, :error?)
        assert_nil(response.data)
        assert_equal(WhatsappSdk::Api::Responses::ErrorResponse, response.error.class)
        assert_equal(404, response.error.status)
      end

      def test_download_media_sends_valid_params
        file_path = "tmp/testing.png"
        @medias_api.expects(:download_file).with(url: url_example, content_type_header: "image/png",
                                                 file_path: file_path)
                   .returns(Net::HTTPOK.new(true, 200, "OK"))
        response = @medias_api.download(url: url_example, file_path: "tmp/testing.png", media_type: "image/png")
        validate_sucess_data_response(response)
      end

      def test_download_raises_an_error_when_media_type_is_invalid
        unsupported_media_type = "audio/vnd.qcelp" # is Unsupported
        error = assert_raises(WhatsappSdk::Api::Medias::InvalidMediaTypeError) do
          @medias_api.download(url: url_example, file_path: "tmp/testing.vnd.qcelp", media_type: unsupported_media_type)
        end

        assert_equal(
          "Invalid Media Type audio/vnd.qcelp. See the supported types in the official documentation " \
          "https://developers.facebook.com/docs/whatsapp/cloud-api/reference/media#supported-media-types.",
          error.message
        )
        assert_equal("audio/vnd.qcelp", error.media_type)
      end

      private

      def url_example
        "www.ignaciochiazzo.com"
      end

      def validate_sucess_data_response(response)
        assert_ok_response(response)
        assert_equal(WhatsappSdk::Api::Responses::SuccessResponse, response.data.class)
        assert_predicate(response.data, :success?)
      end

      def assert_ok_response(response)
        assert_equal(WhatsappSdk::Api::Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
      end

      def mock_error_response(error_response: generic_error_response)
        @medias_api.stubs(:send_request).returns(error_response)
        error_response
      end

      def mock_get_media_response(response)
        @medias_api.stubs(:send_request).returns(response)
        response
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

      def assert_medias_mock_response(expected_media_response, response)
        assert_ok_response(response)

        assert_equal(WhatsappSdk::Api::Responses::MediaDataResponse, response.data.class)
        assert_equal(expected_media_response["id"], response.data.id)
        assert_equal(expected_media_response["url"], response.data.url)
        assert_equal(expected_media_response["mime_type"], response.data.mime_type)
        assert_equal(expected_media_response["sha256"], response.data.sha256)
        assert_equal(expected_media_response["file_size"], response.data.file_size)
        assert_equal(expected_media_response["messaging_product"], response.data.messaging_product)
      end
    end
  end
end
