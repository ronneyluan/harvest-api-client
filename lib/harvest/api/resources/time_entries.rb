module Harvest
  module Api
    module Resources
      class TimeEntries < Base
        TIME_ENTRIES_PATH = '/time_entries'

        def all(page: 1, per_page: 100)
          @options[:query].merge!({ page: page, per_page: per_page })

          get_collection(TIME_ENTRIES_PATH, options: @options) do |page|
            page['time_entries']
          end
        end

        def find(id)
          get("#{TIME_ENTRIES_PATH}/#{id}")
        end

        def in_period(from, to)
          where(from: from, to: to)
        end
      end
    end
  end
end
