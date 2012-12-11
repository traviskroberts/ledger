require 'spec_helper'

describe User do
  describe 'associations' do
    it { should have_and_belong_to_many(:accounts) }
    it { should have_many(:invitations) }
  end
end
