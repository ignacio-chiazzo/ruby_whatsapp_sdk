# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class ContactResponse
      extend T::Sig

      sig { returns(String) }
      attr_accessor :wa_id

      sig { returns(String) }
      attr_accessor :input

      sig { params(input: String, wa_id: String).void }
      def initialize(input:, wa_id:)
        @input = input
        @wa_id = wa_id
      end
    end
  end
end
