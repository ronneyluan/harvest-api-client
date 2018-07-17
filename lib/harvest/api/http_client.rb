module Harvest
  module Api
    module HttpClient
      ERRORS_NAMESPACE = Harvest::Api::Errors

      def base_uri
        raise NotImplementedError
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
