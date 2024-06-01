# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class MediaTypes
      extend T::Sig

      # The media types supported by Whatsapp. The list contains all the types defined in the Whatsapp API
      # documentation: https://developers.facebook.com/docs/whatsapp/cloud-api/reference/media#supported-media-types
      #
      # The media type is used as a content-type header when downloading the file with MediasApi#download_file.
      # The content-type header matches with the media type using Internet Assigned Numbers Authority (IANA).
      # Media type list defined by IANA https://www.iana.org/assignments/media-types/media-types.xhtml
      #
      # NOTE: Cloud API may decide to allow more media types to be downloaded, since the support differs depending on
      # the used client.

      AUDIO_TYPES = T.let(%w[audio/aac audio/mp4 audio/mpeg audio/amr audio/ogg].freeze, T::Array[String])
      DOCUMENT_TYPES = T.let(%w[
        text/plain application/pdf application/vnd.ms-powerpoint application/msword application/vnd.ms-excel
        application/vnd.openxmlformats-officedocument.wordprocessingml.document
        application/vnd.openxmlformats-officedocument.presentationml.presentation
        application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
      ].freeze, T::Array[String])
      IMAGE_TYPES = T.let(%w[image/jpeg image/png].freeze, T::Array[String])
      STICKER_TYPES = T.let(%w[image/webp].freeze, T::Array[String])
      VIDEO_TYPES = T.let(%w[video/mp4 video/3gp].freeze, T::Array[String])

      SUPPORTED_MEDIA_TYPES = T.let([AUDIO_TYPES + DOCUMENT_TYPES + IMAGE_TYPES + STICKER_TYPES + VIDEO_TYPES].flatten.freeze, T::Array[T.untyped])
    end
  end
end
