module Harvest
  module Api
    class << self
      def client(access_token:, account_id: nil)
        client_class = Class.new do
          include Client

          attr_reader :harvest_access_token, :harvest_account_id

          def initialize(harvest_access_token:, harvest_account_id: nil)
            @harvest_access_token = harvest_access_token
            @harvest_account_id = harvest_account_id
          end
        end

        client_class.new(harvest_access_token: access_token,
          harvest_account_id: account_id)
      end
    end
  end
end
