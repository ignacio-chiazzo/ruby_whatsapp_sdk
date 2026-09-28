# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class ContactResponse
      # @!attribute [rw] user_id
      #   Business-scoped user ID, populated only when Graph includes contacts[].user_id.
      #   May be present alongside wa_id; nil when omitted from the response.
      #   @return [String, nil] Business-scoped user ID returned by Graph.
      attr_accessor :wa_id, :input, :user_id

      def initialize(input:, wa_id: nil, user_id: nil)
        @input = input
        @wa_id = wa_id
        @user_id = user_id
      end
    end
  end
end
