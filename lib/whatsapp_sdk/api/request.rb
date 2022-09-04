# frozen_string_literal: true
# typed: strict

module WhatsappSdk
  module Api
    class Request
      extend T::Sig

      extend Forwardable

      def_delegator :@client, :download_file, :send_request

      sig { params(client: WhatsappSdk::Api::Client).void }
      def initialize(client = WhatsappSdk.configuration.client)
        @client = T.let(client, WhatsappSdk::Api::Client)
      end
    end
  end
end
