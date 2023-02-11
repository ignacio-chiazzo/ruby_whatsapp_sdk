# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Email
      extend T::Sig

      sig { returns(String) }
      attr_accessor :email

      sig { returns(AddressType) }
      attr_accessor :type

      sig { params(email: String, type: AddressType).void }
      def initialize(email:, type:)
        @email = email
        @type = type
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_h
        {
          email: @email,
          type: @type
        }
      end
    end
  end
end
