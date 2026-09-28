# frozen_string_literal: true

module WhatsappSdk
  module Resource
    # WhatsApp Business Account fields returned by Graph.
    # Values are retained without conversion; fields omitted from the response are nil.
    class BusinessAccount
      # @!attribute [rw] id
      #   @return [String, nil] Business account ID.
      # @!attribute [rw] name
      #   @return [String, nil] Business account name.
      # @!attribute [rw] timezone_id
      #   @return [String, nil] Graph time zone identifier.
      # @!attribute [rw] message_template_namespace
      #   @return [String, nil] Namespace used by the account's message templates.
      # @!attribute [rw] account_review_status
      #   @return [String, nil] Account review status.
      # @!attribute [rw] business_verification_status
      #   @return [String, nil] Business verification status.
      # @!attribute [rw] country
      #   @return [String, nil] Account country code.
      # @!attribute [rw] ownership_type
      #   @return [String, nil] Account ownership type.
      # @!attribute [rw] primary_business_location
      #   @return [String, nil] Primary business location returned by Graph.
      # @!attribute [rw] analytics
      #   @return [Hash, nil] Messaging analytics, when requested and returned.
      # @!attribute [rw] conversation_analytics
      #   @return [Hash, nil] Conversation analytics, when requested and returned.
      # @!attribute [rw] pricing_analytics
      #   @return [Hash, nil] Pricing analytics, when requested and returned.
      # @!attribute [rw] call_analytics
      #   @return [Hash, nil] Call analytics, when requested and returned.
      attr_accessor :id, :name, :timezone_id, :message_template_namespace, :account_review_status,
                    :business_verification_status, :country, :ownership_type, :primary_business_location,
                    :analytics, :conversation_analytics, :pricing_analytics, :call_analytics

      # Build an account from a Graph response without converting field values.
      #
      # @param hash [Hash{String => Object}] Account fields keyed by their Graph names.
      # @return [BusinessAccount] Account with nil for any missing fields.
      def self.from_hash(hash)
        business_account = BusinessAccount.new
        business_account.id = hash["id"]
        business_account.name = hash["name"]
        business_account.timezone_id = hash["timezone_id"]
        business_account.message_template_namespace = hash["message_template_namespace"]
        business_account.account_review_status = hash["account_review_status"]
        business_account.business_verification_status = hash["business_verification_status"]
        business_account.country = hash["country"]
        business_account.ownership_type = hash["ownership_type"]
        business_account.primary_business_location = hash["primary_business_location"]
        business_account.analytics = hash["analytics"]
        business_account.conversation_analytics = hash["conversation_analytics"]
        business_account.pricing_analytics = hash["pricing_analytics"]
        business_account.call_analytics = hash["call_analytics"]

        business_account
      end

      # Compare account details, excluding analytics fields.
      #
      # @param other [Object] Object to compare with this account.
      # @return [Boolean] Whether the other account has the same core fields.
      def ==(other)
        return false unless other.is_a?(WhatsappSdk::Resource::BusinessAccount)

        %i[id name timezone_id message_template_namespace account_review_status
           business_verification_status country ownership_type primary_business_location].all? do |field|
          send(field) == other.send(field)
        end
      end
    end
  end
end
