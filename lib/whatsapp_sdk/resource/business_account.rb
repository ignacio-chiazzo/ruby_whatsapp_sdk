# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class BusinessAccount
      attr_accessor :id, :name, :timezone_id, :message_template_namespace, :account_review_status,
                    :business_verification_status, :country, :ownership_type, :primary_business_location,
                    :analytics, :conversation_analytics, :pricing_analytics, :template_analytics,
                    :template_group_analytics, :call_analytics

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
        business_account.template_analytics = hash["template_analytics"]
        business_account.template_group_analytics = hash["template_group_analytics"]
        business_account.call_analytics = hash["call_analytics"]

        business_account
      end

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
