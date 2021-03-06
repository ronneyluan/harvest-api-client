module Harvest
  module Api
    module Resources
      class Clients < Base
        CLIENTS_PATH = '/clients'
        CLIENT_PARAMS = %i(name is_active address currency)

        def all(page: 1, per_page: 100)
          @options[:query].merge!({ page: page, per_page: per_page })

          get_collection(CLIENTS_PATH, options: @options) do |page|
            page['clients']
          end
        end

        def find(id)
          get("#{CLIENTS_PATH}/#{id}")
        end

        def create(params: {})
          post(CLIENTS_PATH, params: params.slice(*CLIENT_PARAMS))
        end

        def update(id, params: {})
          patch("#{CLIENTS_PATH}/#{id}", params: params.slice(*CLIENT_PARAMS))
        end

        def destroy(id)
          delete("#{CLIENTS_PATH}/#{id}")
        end
      end
    end
  end
end
