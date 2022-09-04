# frozen_string_literal: true
# typed: strict

module WhatsappSdk
  module Resource
    class PhoneNumber
      extend T::Sig

      sig { returns(String) }
      attr_accessor :phone

      sig { returns(String) }
      attr_accessor :wa_id

      sig { returns(AddressType) }
      attr_accessor :type

      sig { params(phone: String, type: AddressType, wa_id: String).void }
      def initialize(phone:, type:, wa_id:)
        @phone = phone
        @type = type
        @wa_id = wa_id
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_h
        {
          phone: @phone,
          type: @type,
          wa_id: @wa_id
        }
      end
    end
  end
end
