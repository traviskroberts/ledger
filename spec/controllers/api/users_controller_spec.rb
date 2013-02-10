require 'spec_helper'

describe Api::UsersController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :super_admin => true)}

  before :each do
    controller.stub(:current_user => admin)
  end

  describe 'GET #index' do
    it 'should redirect unless current user is an admin' do
      controller.stub(:current_user => user)

      get :index
      expect(response).to redirect_to(root_url)
    end

    it 'should get a list of user accounts' do
      User.should_receive(:all).and_return([user, admin])

      get :index
    end

    it 'should render a json representation of the users' do
      User.stub(:all => [user, admin])

      get :index
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.first.keys).to match_array([:email, :id, :name])
    end
  end
end
