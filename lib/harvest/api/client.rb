require "harvest/api"
require "harvest/api/client/version"
require "harvest/api/client/errors"
require "harvest/api/errors"
require "harvest/api/resources/base"
require "harvest/api/resources/users"
require "harvest/api/resources/time_entries"

module Harvest
  module Api
    module Client
      TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'

      def users
        Resources::Users.new(access_token: config.harvest_access_token,
          account_id: config.harvest_account_id)
      end

      class << self
        def setup
          @@config = OpenStruct.new
          yield(@@config)
        end

        def config
          raise Errors::ConfigError if @@config.harvest_access_token.nil?

          @@config
        end
      end
    end
  end
end
