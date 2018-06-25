module Harvest
  module Api
    module Resources
      class TimeEntries < Base
        TIME_ENTRIES_PATH = '/time_entries'

        def all(page: 1, per_page: 100)
          options = { query: { page: page, per_page: per_page } }

          get(TIME_ENTRIES_PATH, options: options) do |page|
            page['time_entries']
          end
        end

        def from_users(user_id)

        end
      end
    end
  end
end
