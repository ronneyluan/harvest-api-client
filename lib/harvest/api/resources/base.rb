require 'httparty'

module Harvest
  module Api
    module Resources
      class Base
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

        def where(**query_options)
          @options[:query].merge!(query_options)
          self
        end

        protected

        ERRORS_NAMESPACE = Harvest::Api::Errors

        def base_uri
          'https://api.harvestapp.com/v2'
        end

        def perform_request(method, path, options: {})
          HTTParty.send(method, "#{base_uri}#{path}", request_options(options))
        end

        def default_headers
          headers = {
            'Authorization' => "Bearer #{@access_token}",
            'User-Agent' => 'Harvest API Client (ronneyluan@gmail.com)'
          }
          headers['Harvest-Account-ID'] = @account_id if @account_id
          headers
        end

        def request_options(options)
          {
            query:  options[:query],
            body:   options[:body],
            format: :plain,
            headers: default_headers.update(options[:headers] || {})
          }
        end

        def find_account_id
          accounts = Resources::Accounts.new(access_token: @access_token).all
          harvest_account = accounts.find { |a| a["product"] == "harvest" }
          harvest_account.fetch("id") rescue nil
        end

        def handle_response(response)
          case response.code
          when 200..201
            JSON.parse(response.body)
          when 403
            raise ERRORS_NAMESPACE::UnauthorizedError.new(response.code,
              "The object you requested was found but you don’t have authorization to perform this request.")
          when 401
            raise ERRORS_NAMESPACE::InvalidTokenError.new(response.code,
              "The Access token is invalid.")
          when 404
            raise ERRORS_NAMESPACE::NotFoundError.new(response.code,
              "The object you requested can’t be found.")
          when 422
            raise ERRORS_NAMESPACE::UnprocessableEntityError.new(response.code,
              "There were errors processing your request. Check the response body for additional information.")
          when 429
            raise ERRORS_NAMESPACE::ThrottledRequestError.new(response.code,
              "Your request has been throttled.")
          when 500
            raise ERRORS_NAMESPACE::ServerError.new(response.code,
              "There was a server error.")
          else
            raise ERRORS_NAMESPACE::UnknownError.new(response.code,
              "Unknown Error.")
          end
        end
      end
    end
  end
end
