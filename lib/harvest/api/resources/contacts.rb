module Harvest
  module Api
    module Resources
      class Contacts < Base
        CONTACTS_PATH = '/contacts'
        CONTACT_PARAMS = %i(client_id title first_name last_name email
          phone_office phone_mobile fax)

        def all(page: 1, per_page: 100)
          @options[:query].merge!({ page: page, per_page: per_page })

          get_collection(CONTACTS_PATH, options: @options) do |page|
            page['contacts']
          end
        end

        def find(id)
          get("#{CONTACTS_PATH}/#{id}")
        end

        def create(params: {})
          post(CONTACTS_PATH, params: params.slice(*CONTACT_PARAMS))
        end

        def update(id, params: {})
          patch("#{CONTACTS_PATH}/#{id}", params: params.slice(*CONTACT_PARAMS))
        end

        def destroy(id)
          delete("#{CONTACTS_PATH}/#{id}")
        end
      end
    end
  end
end
