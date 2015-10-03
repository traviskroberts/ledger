require "rails_helper"

describe Api::InvitationsController do
  let(:user) { create(:user) }
  let(:account) { create(:account, url: "test-account", users: [user]) }

  before :each do
    allow(controller).to receive(:current_user) { user }
  end

  describe "GET #index" do
    let!(:invite) { create(:invitation, account: account, user: user) }

    it "should get the invitations for the specified account" do
      get :index, account_id: account, format: "json"

      expect(assigns(:invitations)).to eq([invite])
    end
  end

  describe "POST #create" do
    it "should create an invite associated with the account" do
      post :create, account_id: account, invitation: { email: "user@email.com" }, format: "json"

      expect(account.invitations.count).to eq(1)
    end

    it "should create an invite associated with the current user" do
      post :create, account_id: account, invitation: { email: "user@email.com" }, format: "json"

      expect(account.invitations.first.user).to eq(user)
    end

    it "should create a unique token for the invitation" do
      post :create, account_id: account, invitation: { email: "user@email.com" }, format: "json"

      expect(account.invitations.first.token).to be_present
    end

    it "should render a json representation of the invite on success" do
      post :create, account_id: account, invitation: { email: "user@email.com" }, format: "json"
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:account_id, :account_url, :email, :id, :token, :user_id])
    end

    it "should render a 400 error on failure" do
      allow_any_instance_of(Invitation).to receive(:save).and_return(false)
      post :create, account_id: account, format: "json"

      expect(response.status).to eq(400)
    end
  end

  describe "DELETE #destroy" do
    let(:invite) { create(:invitation, account: account, user: user) }

    it "should destroy the specified invitation" do
      delete :destroy, account_id: account, id: invite, format: "json"

      expect(account.invitations.count).to eq(0)
    end

    it 'should render a json representation of the invite on success' do
      delete :destroy, account_id: account, id: invite, format: "json"
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:account_id, :account_url, :email, :id, :token, :user_id])
    end

    it 'should render a 400 error on failure' do
      allow_any_instance_of(Invitation).to receive(:destroy).and_return(false)
      delete :destroy, account_id: account, id: invite, format: "json"

      expect(response.status).to eq(400)
    end
  end
end
