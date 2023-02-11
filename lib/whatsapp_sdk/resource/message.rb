# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Message
      extend T::Sig

      sig { returns(String) }
      attr_reader :id

      sig { params(id: String).void }
      def initialize(id:)
        @id = id
      end
    end
  end
end
