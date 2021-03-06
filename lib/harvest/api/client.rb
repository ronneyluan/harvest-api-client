require "harvest/api"
require "harvest/api/client/version"
require "harvest/api/client/errors"
require "harvest/api/errors"
require "harvest/api/http_client"
require "harvest/api/resources/base"
require "harvest/api/resources/users"
require "harvest/api/resources/time_entries"
require "harvest/api/resources/accounts"
require "harvest/api/resources/projects"
require "harvest/api/resources/clients"
require "harvest/api/resources/contacts"

module Harvest
  module Api
    module Client
      TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'

      def accounts
        Api::Resources::Accounts.new(access_token: harvest_access_token)
      end

      def users
        Api::Resources::Users.new(access_token: harvest_access_token,
          account_id: harvest_account_id)
      end

      def time_entries
        Api::Resources::TimeEntries.new(access_token: harvest_access_token,
          account_id: harvest_account_id)
      end

      def clients
        Api::Resources::Clients.new(access_token: harvest_access_token,
          account_id: harvest_account_id)
      end

      def projects
        Api::Resources::Projects.new(access_token: harvest_access_token,
          account_id: harvest_account_id)
      end

      def contacts
        Api::Resources::Contacts.new(access_token: harvest_access_token,
          account_id: harvest_account_id)
      end

      protected

      def harvest_access_token; end
      def harvest_account_id; end
    end
  end
end
