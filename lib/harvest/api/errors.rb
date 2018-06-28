module Harvest
  module Api
    module Errors
      class HttpClientError < StandardError
        attr_reader :code, :message

        def initialize(code, message)
          @code = code
          @message = message
        end

        def to_s
          "Error code: #{code}, " + (message ? "#{message}" : "")
        end
      end

      class UnauthorizedError < HttpClientError; end
      class NotFoundError < HttpClientError; end
      class UnprocessableEntityError < HttpClientError; end
      class ThrottledRequestError < HttpClientError; end
      class ServerError < HttpClientError; end
      class InvalidTokenError < HttpClientError; end
      class UnknownError < HttpClientError; end
    end
  end
end
