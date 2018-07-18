RSpec.describe Harvest::Api::Resources::Projects do
  subject do
    described_class.new(access_token: ENV['HARVEST_ACCESS_TOKEN'],
      account_id: ENV['HARVEST_ACCOUNT_ID'])
  end

  let(:projec_attributes) do
    %w(id name code is_active is_billable is_fixed_fee bill_by budget budget_by
      budget_is_monthly notify_when_over_budget
      over_budget_notification_percentage show_budget_to_all created_at
      updated_at starts_on ends_on over_budget_notification_date notes
      cost_budget cost_budget_include_expenses hourly_rate fee client)
  end

  describe "#all" do
    it "returns an array" do
      VCR.use_cassette("projects/all") do
        projects = subject.all
        expect(projects).to be_kind_of(Array)
      end
    end

    it 'returns hashes with the correct attributes' do
      VCR.use_cassette("projects/all") do
        expect(subject.all.first.keys).to match_array(projec_attributes)
      end
    end
  end

  describe "#find" do
    let(:id) { '17505036' }

    it "returns a Hash as response" do
      VCR.use_cassette("projects/found") do
        project = subject.find(id)
        expect(project).to be_kind_of(Hash)
      end
    end

    it 'returns hashes with the correct attributes' do
      VCR.use_cassette("projects/found") do
        expect(subject.find(id).keys).to match_array(projec_attributes)
      end
    end
  end
end
