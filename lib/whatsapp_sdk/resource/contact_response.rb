# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class ContactResponse
      attr_accessor :wa_id, :input, :user_id

      def initialize(input:, wa_id: nil, user_id: nil)
        @input = input
        @wa_id = wa_id
        @user_id = user_id
      end
    end
  end
end
