require 'httparty'

module Harvest
  module Api
    module Resources
      class Base
        include Api::HttpClient

        def initialize(access_token:, account_id: nil)
          @access_token = access_token
          @account_id = account_id || find_account_id
          @options = { query: {} }
        end

        def get(path, options: {}, &block)
          response = perform_request(:get, path, options: options)
          parsed_response = handle_response(response)
          block ? block.call(parsed_response) : parsed_response
        end

        def get_collection(path, options: {}, &block)
          pages = []
          response = perform_request(:get, path, options: options)
          page = handle_response(response)
          pages.push(page)

          while page['next_page']
            options[:query][:page] = page['next_page']
            response = perform_request(:get, path, options: options)
            page = handle_response(response)
            pages.push(page)
          end

          pages.reduce([]) do |acc, page|
            acc += block ? block.call(page) : [page]
            acc
          end
        end

        def post(path, params: {}, &block)
          response = perform_request(:post, path, options: { body: params })
          parsed_response = handle_response(response)
          block ? block.call(parsed_response) : parsed_response
        end

        def patch(path, params: {}, &block)
          response = perform_request(:patch, path, options: { body: params })
          parsed_response = handle_response(response)
          block ? block.call(parsed_response) : parsed_response
        end

        def delete(path, &block)
          response = perform_request(:delete, path)
          parsed_response = handle_response(response)
          block ? block.call(parsed_response) : parsed_response
        end

        def where(**query_options)
          @options[:query].merge!(query_options)
          self
        end

        protected

        def base_uri
          'https://api.harvestapp.com/v2'
        end

        def find_account_id
          accounts = Resources::Accounts.new(access_token: @access_token).all
          harvest_account = accounts.find { |a| a["product"] == "harvest" }
          harvest_account.fetch("id").to_s rescue nil
        end
      end
    end
  end
end
