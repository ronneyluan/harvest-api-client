module Harvest
  module Api
    module Resources
      class Projects < Base
        PROJECTS_PATH = '/projects'

        def all(page: 1, per_page: 100)
          @options[:query].merge!({ page: page, per_page: per_page })

          get_collection(PROJECTS_PATH, options: @options) do |page|
            page['projects']
          end
        end

        def find(id)
          get("#{PROJECTS_PATH}/#{id}")
        end
      end
    end
  end
end
