require "harvest/api"
require "harvest/api/client/version"
require "harvest/api/client/errors"
require "harvest/api/errors"
require "harvest/api/resources/base"
require "harvest/api/resources/users"
require "harvest/api/resources/time_entries"
require "harvest/api/resources/accounts"

module Harvest
  module Api
    module Client
      TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'

      def users
        Resources::Users.new(access_token: harvest_access_token,
          account_id: harvest_account_id)
      end

      def time_entries
        Resources::TimeEntries.new(access_token: harvest_access_token,
          account_id: harvest_account_id)
      end

      def accounts
        Resources::Accounts.new(access_token: harvest_access_token)
      end

      protected

      def harvest_access_token; end
      def harvest_account_id; end
    end
  end
end
