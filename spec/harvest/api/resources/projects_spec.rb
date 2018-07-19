RSpec.describe Harvest::Api::Resources::Projects do
  subject do
    described_class.new(access_token: ENV['HARVEST_ACCESS_TOKEN'],
      account_id: ENV['HARVEST_ACCOUNT_ID'])
  end

  let(:project_attributes) do
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
        expect(subject.all.first.keys).to match_array(project_attributes)
      end
    end
  end

  describe "#find" do
    let(:id) { subject.all.first['id'] }

    it "returns a Hash as response" do
      VCR.use_cassette("projects/found") do
        project = subject.find(id)
        expect(project).to be_kind_of(Hash)
      end
    end

    it 'returns hashes with the correct attributes' do
      VCR.use_cassette("projects/found") do
        expect(subject.find(id).keys).to match_array(project_attributes)
      end
    end
  end

  describe "#create" do
    let(:clients) do
      Harvest::Api::Resources::Clients.new(access_token: ENV['HARVEST_ACCESS_TOKEN'],
        account_id: ENV['HARVEST_ACCOUNT_ID'])
    end

    let(:project_params) do
      { client_id: clients.all.first['id'], name: 'My new Project',
        is_billable: false, bill_by: 'none', budget_by: 'none' }
    end

    it "returns a hash as response" do
      VCR.use_cassette("projects/new") do
        response = subject.create(params: project_params)
        expect(response).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes" do
      VCR.use_cassette("projects/new") do
        response = subject.create(params: project_params)
        expect(response.keys).to match_array(project_attributes)
      end
    end

    it "returns the created project" do
      VCR.use_cassette("projects/new") do
        response = subject.create(params: project_params)
        expect(response['name']).to eq(project_params[:name])
      end
    end
  end

  describe "#update" do
    let(:id) { subject.all.first['id'] }
    let(:update_params) do
      { name: "My updated Project" }
    end

    it "returns an array as response" do
      VCR.use_cassette("projects/updated") do
        response = subject.update(id, params: update_params)
        expect(response).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes" do
      VCR.use_cassette("projects/updated") do
        response = subject.update(id, params: update_params)
        expect(response.keys).to match_array(project_attributes)
      end
    end

    it "returns the updated project" do
      VCR.use_cassette("projects/updated") do
        response = subject.update(id, params: update_params)
        expect(response['name']).to eq(update_params[:name])
      end
    end
  end

  describe "#destroy" do
    let(:id) { subject.all.first['id'] }

    it "returns the deleted project as response" do
      VCR.use_cassette("projects/destroyed") do
        response = subject.destroy(id)
        expect(response).to be_kind_of(Hash)
      end
    end
  end
end
