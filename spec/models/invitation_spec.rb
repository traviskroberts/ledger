require 'spec_helper'

describe Invitation do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:token) }
  end
end
