module Harvest
  module Api
    module Resources
      class Projects < Base
        PROJECTS_PATH = '/projects'
        PROJECTS_PARAMS = %i(client_id name code is_active is_billable
          is_fixed_fee bill_by hourly_rate budget budget_by budget_is_monthly
          notify_when_over_budget over_budget_notification_percentage
          show_budget_to_all cost_budget cost_budget_include_expenses
          fee notes starts_on ends_on)

        def all(page: 1, per_page: 100)
          @options[:query].merge!({ page: page, per_page: per_page })

          get_collection(PROJECTS_PATH, options: @options) do |page|
            page['projects']
          end
        end

        def find(id)
          get("#{PROJECTS_PATH}/#{id}")
        end

        def create(params: {})
          post(PROJECTS_PATH, params: params.slice(*PROJECTS_PARAMS))
        end

        def update(id, params: {})
          patch("#{PROJECTS_PATH}/#{id}", params: params.slice(*PROJECTS_PARAMS))
        end

        def destroy(id)
          delete("#{PROJECTS_PATH}/#{id}")
        end
      end
    end
  end
end
