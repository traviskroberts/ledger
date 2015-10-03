require "rails_helper"

describe Api::UsersController do
  let(:user) { create(:user) }
  let(:admin) { create(:user, super_admin: true)}

  describe "GET #index" do
    context "user is a super admin" do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it "should render a json representation of all users" do
        get :index
        jsr = JSON.parse(response.body, :symbolize_names => true)

        expect(jsr.first.keys).to match_array([:email, :id, :name])
      end
    end

    context "user is not a super admin" do
      before :each do
        allow(controller).to receive(:current_user) { user }
      end

      it "should redirect to home page" do
        get :index

        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST #create" do
    let(:user_params) {
      {
        name: "Test User",
        email: "test@email.com",
        password: "test1234",
        password_confirmation: "test1234"
      }
    }

    context "request is successful" do
      before do
        allow(UserSession).to receive(:create)

        post :create, user: user_params, format: "json"
      end

      it "creates a new user" do
        expect(User.count).to eq(1)
      end

      it "logs the user in" do
        expect(UserSession).to have_received(:create)
      end

      it "returns a json representation of the new user" do
        jsr = JSON.parse(response.body, symbolize_names: true)

        expect(jsr.keys).to match_array([:id, :name, :email])
      end
    end

    context "request is not successful" do
      before do
        allow_any_instance_of(User).to receive(:save).and_return(false)

        post :create, user: user_params, format: "json"
      end

      it "renders a json representation of the errors" do
        jsr = JSON.parse(response.body, symbolize_names: true)

        expect(jsr.keys).to eq([:errors])
      end

      it "returns a 400 status" do
        expect(response.status).to eq(400)
      end
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user) }
    let(:user_params) {
      {
        name: "Test User",
        email: "test@email.com",
        password: "test1234",
        password_confirmation: "test1234"
      }
    }

    before do
      allow(controller).to receive(:current_user) { user }
    end

    context "request is successful" do
      before do
        allow(UserSession).to receive(:create)

        put :update, user: user_params, format: "json"
      end

      it "re-logs the user in" do
        expect(UserSession).to have_received(:create)
      end

      it "returns a json representation of the user" do
        jsr = JSON.parse(response.body, symbolize_names: true)

        expect(jsr.keys).to match_array([:id, :name, :email])
      end
    end

    context "request is not successful" do
      before do
        allow_any_instance_of(User).to receive(:update_attributes).and_return(false)

        put :update, user: user_params, format: "json"
      end

      it "renders a json representation of the errors" do
        jsr = JSON.parse(response.body, symbolize_names: true)

        expect(jsr.keys).to eq([:errors])
      end

      it "returns a 400 status" do
        expect(response.status).to eq(400)
      end
    end
  end
end
