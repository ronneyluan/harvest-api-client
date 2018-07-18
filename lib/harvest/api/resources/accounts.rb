module Harvest
  module Api
    module Resources
      class Accounts < Base
        def initialize(access_token:)
          @access_token = access_token
        end

        def all
          get(ACCOUNTS_PATH) do |user_accounts|
            user_accounts['accounts']
          end
        end

        protected

        ACCOUNTS_PATH = '/accounts'

        def base_uri
          'https://id.getharvest.com/api/v2'
        end
      end
    end
  end
end
