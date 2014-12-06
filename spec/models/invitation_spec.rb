require "rails_helper"

describe Invitation do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:token) }
    it { should validate_presence_of(:user) }
  end

  describe '#as_json' do
    it 'json representation should only include the specified fields' do
      invitation = FactoryGirl.create(:invitation)
      json = JSON.parse(invitation.to_json, :symbolize_names => true)
      expect(json.keys).to match_array([:account_id, :user_id, :email, :token])
    end
  end
end
