# typed: strict
# frozen_string_literal: true

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

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_h
        {
          url: @url,
          type: @type
        }
      end
    end
  end
end
