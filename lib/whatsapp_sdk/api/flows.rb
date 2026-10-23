# frozen_string_literal: true

require_relative 'request'

module WhatsappSdk
  module Api
    # Manage Flow drafts and publish them explicitly through the configured client.
    # @see https://developers.facebook.com/docs/whatsapp/flows/reference/flowsapi
    class Flows < Request
      # @param business_id [String, Integer] WhatsApp Business Account ID.
      # @param limit [Integer] Maximum records per page.
      # @param after [String, nil] Cursor from the previous page.
      # @param fields [Array<String>, nil] Optional Graph fields to retrieve.
      # @return [Responses::PaginationRecords] Page containing raw Flow hashes and cursors.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def list(business_id:, limit: 100, after: nil, fields: nil)
        params = { limit: limit }
        params[:after] = after if after
        params[:fields] = fields.join(',') if fields
        response = send_request(endpoint: "#{business_id}/flows", http_method: 'get', params: params)

        Responses::PaginationRecords.new(
          records: response['data'],
          before: response.dig('paging', 'cursors', 'before'),
          after: response.dig('paging', 'cursors', 'after')
        )
      end

      # @param flow_id [String, Integer] Flow ID.
      # @param fields [Array<String>, nil] Fields to retrieve; nil uses Graph's default fields.
      # @return [Hash] Raw Flow details, including status and validation errors.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def get(flow_id:, fields: nil)
        params = fields ? { fields: fields.join(',') } : {}
        send_request(endpoint: flow_id.to_s, http_method: 'get', params: params)
      end

      # Create a draft; upload_json and publish are separate, explicit operations.
      # @param business_id [String, Integer] WhatsApp Business Account ID.
      # @param name [String] Flow name.
      # @param categories [Array<String>] Flow categories accepted by Graph, such as SURVEY.
      # @param endpoint_uri [String, nil] Optional data exchange endpoint URL.
      # @return [Hash] Raw creation response, including id and any validation errors.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def create(business_id:, name:, categories:, endpoint_uri: nil)
        params = { name: name, categories: categories }
        params[:endpoint_uri] = endpoint_uri if endpoint_uri
        send_request(endpoint: "#{business_id}/flows", params: params,
                     headers: { 'Content-Type' => 'application/json' })
      end

      # List assets without downloading their contents.
      # @param flow_id [String, Integer] Flow ID.
      # @param limit [Integer] Maximum records per page.
      # @param after [String, nil] Cursor from the previous page.
      # @return [Responses::PaginationRecords] Page of raw asset hashes, including download_url, and cursors.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def assets(flow_id:, limit: 100, after: nil)
        params = { limit: limit }
        params[:after] = after if after
        response = send_request(endpoint: "#{flow_id}/assets", http_method: 'get', params: params)

        Responses::PaginationRecords.new(
          records: response['data'],
          before: response.dig('paging', 'cursors', 'before'),
          after: response.dig('paging', 'cursors', 'after')
        )
      end

      # Upload Flow JSON as multipart data. The file is closed after the request, including on errors.
      # @param flow_id [String, Integer] Draft Flow ID.
      # @param file_path [String] Path to the Flow JSON file.
      # @return [Hash] Raw response; inspect validation_errors even when success is true.
      # @raise [Medias::FileNotFoundError] If the path does not identify a regular file.
      # @raise [SystemCallError] If the file cannot be opened or read.
      # @raise [Responses::HttpResponseError] If Graph rejects the request.
      def upload_json(flow_id:, file_path:)
        raise Medias::FileNotFoundError.new(file_path: file_path) unless File.file?(file_path)

        File.open(file_path, 'rb') do |file|
          params = { name: 'flow.json', asset_type: 'FLOW_JSON',
                     file: Faraday::FilePart.new(file, 'application/json', 'flow.json') }
          send_request(endpoint: "#{flow_id}/assets", params: params, multipart: true)
        end
      end

      # @param flow_id [String, Integer] Draft Flow ID to publish.
      # @return [Hash] Raw publish response containing success.
      # @raise [Responses::HttpResponseError] If Graph rejects publication.
      def publish(flow_id:)
        send_request(endpoint: "#{flow_id}/publish")
      end
    end
  end
end
