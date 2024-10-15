# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Media
      # Returns media id.
      #
      # @returns id [String].
      attr_accessor :id

      module Type
        AUDIO = 'audio'
        DOCUMENT = 'document'
        IMAGE = 'image'
        VIDEO = 'video'
        STICKER = 'sticker'
      end

      attr_accessor :file_size, :id, :messaging_product, :mime_type, :sha256, :url

      def self.from_hash(hash)
        media = new
        media.id = hash["id"]
        media.file_size = hash["file_size"]
        media.messaging_product = hash["messaging_product"]
        media.mime_type = hash["mime_type"]
        media.sha256 = hash["sha256"]
        media.url = hash["url"]
        media
      end

      def ==(other)
        self.id == other.id &&
          self.file_size == other.file_size &&
          self.messaging_product == other.messaging_product &&
          self.mime_type == other.mime_type &&
          self.sha256 == other.sha256 &&
          self.url == other.url
      end
    end
  end
end
