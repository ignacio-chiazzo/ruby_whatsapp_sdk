# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class TemplateAnalytic
      module Granularity
        DAILY = "DAILY"
      end

      module MetricType
        COST = "COST"
        CLICKED = "CLICKED"
        DELIVERED = "DELIVERED"
        READ = "READ"
        SENT = "SENT"

        # (MM API for WhatsApp only)
        APP_ACTIVATIONS = "APP_ACTIVATIONS"
        APP_ADD_TO_CART = "APP_ADD_TO_CART"
        APP_CHECKOUTS_INITIATED = "APP_CHECKOUTS_INITIATED"
        APP_PURCHASES = "APP_PURCHASES"
        APP_PURCHASES_CONVERSION_VALUE = "APP_PURCHASES_CONVERSION_VALUE"
        WEBSITE_ADD_TO_CART = "WEBSITE_ADD_TO_CART"
        WEBSITE_CHECKOUTS_INITIATED = "WEBSITE_CHECKOUTS_INITIATED"
        WEBSITE_PURCHASES = "WEBSITE_PURCHASES"
        WEBSITE_PURCHASES_CONVERSION_VALUE = "WEBSITE_PURCHASES_CONVERSION_VALUE"

        METRIC_TYPES = [COST, CLICKED, DELIVERED, READ, SENT, APP_ACTIVATIONS, APP_ADD_TO_CART, APP_CHECKOUTS_INITIATED,
                        APP_PURCHASES, APP_PURCHASES_CONVERSION_VALUE, WEBSITE_ADD_TO_CART, WEBSITE_CHECKOUTS_INITIATED,
                        WEBSITE_PURCHASES, WEBSITE_PURCHASES_CONVERSION_VALUE].freeze

        def self.valid?(metric_type)
          METRIC_TYPES.include?(metric_type)
        end
      end

      attr_accessor :granularity, :product_type, :data_points

      def initialize(granularity:, product_type:, data_points:)
        @granularity = granularity
        @product_type = product_type
        @data_points = data_points
      end

      def self.from_hash(hash)
        new(
          granularity: hash["granularity"],
          product_type: hash["product_type"],
          data_points: hash["data_points"]
        )
      end
    end
  end
end
