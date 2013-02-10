require 'spec_helper'

describe UsersController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:admin) { FactoryGirl.build_stubbed(:user, :super_admin => true)}

  describe 'GET #new' do
    it 'should create an instance of User' do
      get :new

      expect(assigns(:user).class).to eq(User)
    end
  end

  describe 'POST #create' do
    before :each do
      User.any_instance.stub(:save => true)
      UserSession.stub(:create)
    end

    it 'should create a new user account' do
      User.any_instance.should_receive(:save).and_return(true)

      post :create, :user => {:email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234'}
    end

    it 'should set a flash message on success' do
      post :create, :user => {:email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234'}
      expect(flash[:success]).to be_present
    end

    it 'should log the user in on success' do
      UserSession.should_receive(:create).with(anything, true)

      post :create, :user => {:email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234'}
    end

    it 'should redirect to the accounts url on success' do
      post :create, :user => {:email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234'}
      expect(response).to redirect_to(accounts_url)
    end

    it 'should set a flash message on failure' do
      User.any_instance.stub(:save => false)

      post :create, :user => {}
      expect(flash[:error]).to be_present
    end

    it 'should render the #new template on failure' do
      User.any_instance.stub(:save => false)

      post :create, :user => {}
      expect(response).to render_template('users/new')
    end
  end
end
