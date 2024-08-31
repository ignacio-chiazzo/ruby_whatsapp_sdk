# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Url
      attr_accessor :url, :type

      def initialize(url:, type:)
        @url = url
        @type = type
      end

      def to_h
        {
          url: @url,
          type: @type
        }
      end
    end
  end
end
