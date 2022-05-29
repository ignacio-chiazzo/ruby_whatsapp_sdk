# frozen_string_literal: true

module Whatsapp
  module Resource
    class Url
      attr_accessor :url, :type

      ADDRESS_TYPE = {
        home: "HOME",
        work: "WORK"
      }.freeze

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
