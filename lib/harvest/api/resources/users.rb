module Harvest
  module Api
    module Resources
      class Users < Base
        USERS_PATH = '/users'

        def current
          get("#{USERS_PATH}/me") 
        end

        def all(page: 1, per_page: 100)
          options = { query: { page: page, per_page: per_page } }

          get(USERS_PATH, options: options) do |parsed_response|
            parsed_response['users']
          end
        end

        def active(page: 1, per_page: 100)
          options = {
            query: { page: page, per_page: per_page, is_active: true }
          }

          get(USERS_PATH, options: options) do |parsed_response|
            parsed_response['users']
          end
        end

        def updated_since(time, page: 1, per_page: 100)
          options = {
            query: {
              page: page,
              per_page: per_page,
              updated_since: time.strftime(Harvest::Api::Client::TIME_FORMAT)
            }
          }

          get(USERS_PATH, options: options) do |parsed_response|
            parsed_response['users']
          end
        end

        def find(id)
          get("#{USERS_PATH}/#{id}")
        end
      end
    end
  end
end
