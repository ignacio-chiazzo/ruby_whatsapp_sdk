# frozen_string_literal: true

module Whatsapp
  module Resource
    class ContactResponse
      attr_accessor :input, :wa_id

      def initialize(input:, wa_id:)
        @input = input
        @wa_id = wa_id
      end
    end
  end
end
