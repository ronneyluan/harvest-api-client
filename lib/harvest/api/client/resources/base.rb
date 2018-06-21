module Harvest::Api::Client
  module Resources
    class Base
      def initialize(access_token:, account_id:)
        @access_token = access_token
        @account_id = account_id
      end

      def request(method, path, options: {})
        perform_request(method, path, options: {})
      end

      private

      API_BASE_UR = 'https://api.harvestapp.com'

      def perform_request(method, path, options: {})
        HTTParty.send(method, "#{api_base_url}#{path}", request_options(options))
      end

      def api_base_url
        ENV['API_BASE_UR'] || API_BASE_UR
      end

      def default_headers
        {
          'Harvest-Account-ID' => @account_id,
          'Authorization' => "Bearer #{@access_token}",
          'User-Agent' => 'Harvest API Client (ronneyluan@gmail.com)'
        }
      end

      def request_options(options)
        {
           query:  options[:query],
           body:   options[:body],
           format: :plain,
           headers: default_headers.update(options[:headers] || {})
         }
      end
    end
  end
end
