require 'spec_helper'

describe SiteController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.build_stubbed(:user) }

  describe 'GET #index' do
    it 'should render the index if the user is not logged in' do
      get :index
      expect(response).to render_template('site/index')
    end

    it 'should redirect to the accounts index if the user is logged in' do
      controller.stub(:current_user => user)

      get :index
      expect(response).to redirect_to(accounts_url)
    end
  end
end
