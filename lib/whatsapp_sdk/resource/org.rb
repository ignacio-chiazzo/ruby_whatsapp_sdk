# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Org
      attr_accessor :company, :department, :title

      def initialize(company:, department:, title:)
        @company = company
        @department = department
        @title = title
      end

      def to_h
        {
          company: @company,
          department: @department,
          title: @title
        }
      end
    end
  end
end
