require 'spec_helper'

describe Api::UsersController do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :super_admin => true)}

  before :each do
    activate_authlogic
  end

  describe 'GET #index' do
    it 'should redirect unless current user is an admin' do
      UserSession.create(user)

      get :index
      expect(response).to redirect_to(root_url)
    end

    it 'should get a list of user accounts' do
      UserSession.create(admin)
      3.times { FactoryGirl.create(:user) }

      get :index
      expect(assigns(:users).length).to eq(4)
    end

    it 'should render a json representation of the users' do
      UserSession.create(admin)
      3.times { FactoryGirl.create(:user) }

      get :index
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.first.keys).to match_array([:email, :id, :name])
    end
  end
end
