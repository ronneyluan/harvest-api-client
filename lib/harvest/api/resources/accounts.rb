module Harvest
  module Api
    module Resources
      class Accounts < Base
        ACCOUNTS_PATH = '/accounts'

        def all
          get(ACCOUNTS_PATH) do |user_accounts|
            user_accounts['accounts']
          end
        end

        protected

        def base_uri
          'https://id.getharvest.com/api/v2'
        end
      end
    end
  end
end
