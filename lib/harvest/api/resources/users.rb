module Harvest
  module Api
    module Resources
      class Users < Base
        def current
          get('/users/me') do |response|
            JSON.parse(response)
          end
        end

        def all(options: {})
          get('/users', options) do |response|
            parsed_response = JSON.parse(response)
            parsed_response['users']
          end
        end

        def filter(query: {})
          get('/users', options: { query: query }) do |response|
            parsed_response = JSON.parse(response)
            parsed_response['users']
          end
        end

        def find(id)
          get("/users/#{id}") do |response|
            JSON.parse(response)
          end
        end
      end
    end
  end
end
