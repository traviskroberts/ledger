require "rails_helper"

describe Api::UserSessionsController do
  let(:user) { create(:user) }
  let(:valid_params) { { email: "user@email.com", password: "test1234"} }

  before :each do
    allow(controller).to receive(:current_user) { user }
  end

  describe "POST #create" do
    context "valid request" do
      before do
        allow_any_instance_of(UserSession).to receive(:save).and_return(true)
      end

      it "should render a a json representation of the user" do
        post :create, :user_session => valid_params
        jsr = JSON.parse(response.body, :symbolize_names => true)

        expect(jsr.keys).to match_array([:id, :name, :email])
      end
    end

    context "invalid params" do
      before do
        allow_any_instance_of(UserSession).to receive(:save).and_return(false)
      end

      it "should render a json representation of the errors" do
        post :create, :user_session => valid_params
        jsr = JSON.parse(response.body, :symbolize_names => true)

        expect(jsr.keys).to match_array([:errors])
      end

      it 'should render a 400 status' do
        post :create, :user_session => valid_params

        expect(response.status).to eq(400)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:session_double) { double("userSession") }

    before do
      allow(controller).to receive(:current_user_session) { session_double }
      allow(session_double).to receive(:destroy)
    end

    it "should destroy the user session" do
      delete :destroy

      expect(session_double).to have_received(:destroy)
    end
  end
end
