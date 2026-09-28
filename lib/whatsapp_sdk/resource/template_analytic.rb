# frozen_string_literal: true

module WhatsappSdk
  module Resource
    # Template analytics for one aggregation interval and product type.
    # Metric data points are retained as raw Graph hashes without conversion.
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

      # @!attribute [rw] granularity
      #   @return [String, nil] Aggregation interval, such as DAILY.
      # @!attribute [rw] product_type
      #   @return [String, nil] Messaging product, such as cloud_api.
      # @!attribute [rw] data_points
      #   @return [Array<Hash>, nil] Raw per-template metrics and time ranges.
      attr_accessor :granularity, :product_type, :data_points

      # Construct an analytics record without validating or converting its fields.
      #
      # @param granularity [String, nil] Aggregation interval returned by Graph.
      # @param product_type [String, nil] Messaging product returned by Graph.
      # @param data_points [Array<Hash>, nil] Raw per-template metrics and time ranges.
      # @return [TemplateAnalytic] Analytics record containing the supplied values.
      def initialize(granularity:, product_type:, data_points:)
        @granularity = granularity
        @product_type = product_type
        @data_points = data_points
      end

      # Build an analytics record from a Graph response.
      #
      # @param hash [Hash{String => Object}] Analytics fields keyed by their Graph names.
      # @return [TemplateAnalytic] Analytics record with nil for any missing fields.
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
