# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class ContactResponse
      attr_accessor :wa_id, :input

      def initialize(input:, wa_id:)
        @input = input
        @wa_id = wa_id
      end
    end
  end
end
