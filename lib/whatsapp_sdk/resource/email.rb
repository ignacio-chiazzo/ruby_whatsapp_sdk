# frozen_string_literal: true
# typed: true

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

      sig { returns(Hash) }
      def to_h
        {
          email: @email,
          type: @type
        }
      end
    end
  end
end
