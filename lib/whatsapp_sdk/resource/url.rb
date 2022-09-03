# frozen_string_literal: true
# typed: true

module WhatsappSdk
  module Resource
    class Url
      extend T::Sig

      sig { returns(String) }
      attr_accessor :url

      sig { returns(AddressType) }
      attr_accessor :type

      sig { params(url: String, type: AddressType).void }
      def initialize(url:, type:)
        @url = url
        @type = type
      end

      sig { returns(Hash) }
      def to_h
        {
          url: @url,
          type: @type
        }
      end
    end
  end
end
