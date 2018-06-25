module Harvest
  module Api
    module Resources
      class TimeEntries < Base
        TIME_ENTRIES_PATH = '/time_entries'

        def all(page: 1, per_page: 100)
          page_options = { query: { page: page, per_page: per_page } }
          @options = @options.update(page_options)

          get_collection(TIME_ENTRIES_PATH, options: @options) do |page|
            page['time_entries']
          end
        end

        def find(id)
          get("#{TIME_ENTRIES_PATH}/#{id}")
        end

        def in_period(from_date, to_date)
          period_options = { query: { from: from_date, per_page: to_date } }
          @options = @options.update(period_options)
          self
        end

        def updated_since(date)
          period_options = { query: { updated_since: date } }
          @options = @options.update(period_options)
          self
        end

        def from_user(user_id)
          user_options = { query: { user_id: user_id } }
          @options = @options.update(user_options)
          self
        end
      end
    end
  end
end
