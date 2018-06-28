module Harvest
  module Api
    class << self
      def client
        Class.new do
          include Client

          attr_reader :harvest_access_token, :harvest_account_id

          def initialize(harvest_access_token:, harvest_account_id: nil)
            @harvest_access_token = harvest_access_token
            @harvest_account_id = harvest_account_id
          end
        end
      end
    end
  end
end
