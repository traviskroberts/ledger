require "rails_helper"

describe User do
  describe "associations" do
    it { should have_and_belong_to_many(:accounts) }
    it { should have_many(:invitations) }
  end

  describe "#as_json" do
    it "json representation should only include the specified fields" do
      user = FactoryGirl.create(:user)
      json = JSON.parse(user.to_json, symbolize_names: true)
      expect(json.keys).to match_array([:id, :name, :email])
    end
  end
end
