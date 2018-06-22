require "harvest/api"
require "harvest/api/client/version"
require "harvest/api/errors"
require "harvest/api/resources/base"
require "harvest/api/resources/users"

module Harvest
  module Api
    module Client
      def users
        Resources::Users.new(access_token: Api.config.harvest_access_token,
          account_id: Api.config.harvest_account_id)
      end
    end
  end
end
