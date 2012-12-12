require 'spec_helper'

describe SiteController do

  let(:user) { FactoryGirl.create(:user) }

  before :each do
    activate_authlogic
  end

  describe 'GET #index' do
    it 'should render the index if the user is not logged in' do
      get :index
      expect(response).to render_template('site/index')
    end

    it 'should redirect to the accounts index if the user is logged in' do
      UserSession.create(user)

      get :index
      expect(response).to redirect_to(accounts_url)
    end
  end
end
