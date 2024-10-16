# frozen_string_literal: true

module WhatsappSdk
  module Api
    module Responses
      class PaginationRecords
        attr_reader :records, :before, :after

        def initialize(records:, before:, after:)
          @records = records
          @before = before
          @after = after
        end
      end
    end
  end
end
