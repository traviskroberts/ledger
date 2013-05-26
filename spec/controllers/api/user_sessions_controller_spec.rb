require 'spec_helper'

describe Api::UserSessionsController do
  include NullDB::RSpec::NullifiedDatabase

  let(:valid_params) { {'email' => 'user@email.com', 'password' => 'test1234'} }
  let(:user) { FactoryGirl.build_stubbed(:user) }

  before :each do
    UserSession.any_instance.stub(:save => true)
    controller.stub(:current_user => user)
    user.stub(:save => true)
  end

  describe 'POST #create' do
    context 'valid request' do
      it 'should build a new user session' do
        UserSession.should_receive(:new).and_return(user)

        post :create, :user_session => valid_params
      end

      it 'should save the user session' do
        UserSession.any_instance.should_receive(:save).and_return(true)

        post :create, :user_session => valid_params
      end

      it 'should render a a json representation of the user' do
        post :create, :user_session => valid_params
        jsr = JSON.parse(response.body, :symbolize_names => true)
        expect(jsr.keys).to match_array([:id, :name, :email])
      end
    end

    context 'invalid params' do
      it 'should render a json representation of the errors' do
        UserSession.any_instance.stub(:save => false)
        post :create, :user_session => valid_params
        jsr = JSON.parse(response.body, :symbolize_names => true)
        expect(jsr.keys).to match_array([:errors])
      end

      it 'should render a 400 status' do
        UserSession.any_instance.stub(:save => false)
        post :create, :user_session => valid_params
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should destroy the user session' do
      controller.stub(:current_user_session => user)
      user.should_receive(:destroy)

      delete :destroy
    end
  end

end
