RSpec.describe Harvest::Api::Resources::Clients do
  subject do
    described_class.new(access_token: ENV['HARVEST_ACCESS_TOKEN'],
      account_id: ENV['HARVEST_ACCOUNT_ID'])
  end

  let(:client_params) do
    { name: 'MR Festas' }
  end

  let(:client_attributes) do
    %w(id name is_active address created_at updated_at currency)
  end

  describe "#create" do
    it "returns a hash as response" do
      VCR.use_cassette("clients/new") do
        response = subject.create(params: client_params)
        expect(response).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes" do
      VCR.use_cassette("clients/new") do
        response = subject.create(params: client_params)
        expect(response.keys).to match_array(client_attributes)
      end
    end

    it "returns the created client" do
      VCR.use_cassette("clients/new") do
        response = subject.create(params: client_params)
        expect(response[:name]).to eq(client_params['name'])
      end
    end
  end

  describe "#all" do
    it "returns an array as response" do
      VCR.use_cassette("clients/all") do
        expect(subject.all).to be_kind_of(Array)
      end
    end

    it "returns the correct attributes for array items" do
      VCR.use_cassette("clients/all") do
        expect(subject.all.first.keys).to match_array(client_attributes)
      end
    end
  end

  describe "#find" do
    let(:id) { subject.all.first['id'] }

    it "returns an array as response" do
      VCR.use_cassette("clients/found") do
        expect(subject.find(id)).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes" do
      VCR.use_cassette("clients/found") do
        expect(subject.find(id).keys).to match_array(client_attributes)
      end
    end
  end

  describe "#update" do
    let(:id) { subject.all.first['id'] }
    let(:update_params) do
      { address: "Some street, 19, Some city" }
    end

    it "returns an array as response" do
      VCR.use_cassette("clients/updated") do
        response = subject.update(id, params: update_params)
        expect(response).to be_kind_of(Hash)
      end
    end

    it "returns the correct attributes" do
      VCR.use_cassette("clients/updated") do
        response = subject.update(id, params: update_params)
        expect(response.keys).to match_array(client_attributes)
      end
    end

    it "returns the updated client" do
      VCR.use_cassette("clients/updated") do
        response = subject.update(id, params: update_params)
        expect(response['address']).to eq(update_params[:address])
      end
    end
  end

  describe "#destroy" do
    let(:id) { subject.all.first['id'] }

    it "returns the deleted client as response" do
      VCR.use_cassette("clients/destroyed") do
        response = subject.destroy(id)
        expect(response).to be_kind_of(Hash)
      end
    end
  end
end
