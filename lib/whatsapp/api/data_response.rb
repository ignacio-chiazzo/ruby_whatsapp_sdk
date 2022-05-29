require_relative "request"
require_relative "../resource/message"
require_relative "../resource/contact_response"

module Whatsapp
  module Api
    class DataResponse
      def self.build_from_response(response:)
        raise NotImplemented
      end
    end
  end
end
