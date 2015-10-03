require "rails_helper"

describe Api::AccountsController do
  let(:user) { create(:user) }
  let(:account) { create(:account, users: [user]) }

  before :each do
    allow(controller).to receive(:current_user) { user }
  end

  describe "GET #index" do
    let!(:acct1) { create(:account, users: [user]) }
    let!(:acct2) { create(:account, users: [user]) }

    it "should retrieve the accounts for the current user" do
      get :index

      expect(assigns(:accounts)).to eq([acct1, acct2])
    end

    it 'should return a 401 error if the user is not authenticated' do
      allow(controller).to receive(:current_user) { nil }
      get :index

      expect(response.status).to eq(401)
    end
  end

  describe "GET #show" do
    before do
      get :show, id: account, format: "json"
    end

    it "should retrieve the specified account" do
      expect(assigns(:account)).to eq(account)
    end

    it "should render a json representation of the account" do
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end
  end

  describe "POST #create" do
    let(:valid_parameters) { attributes_for(:account) }

    it "should create a new account associated with the user" do
      post :create, :account => valid_parameters

      expect(user.accounts.count).to eq(1)
    end

    it "should render a json representation of the account" do
      post :create, :account => valid_parameters
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end

    it "should render a 400 error on failure" do
      post :create, :account => {}

      expect(response.status).to eq(400)
    end
  end

  describe "PUT #update" do
    let(:account) { create(:account, url: "test-account", users: [user]) }
    let(:updated_parameters) { { name: "Changed Account Name" } }

    it "should update the attributes" do
      put :update, id: account, account: updated_parameters

      expect(account.reload.name).to eq(updated_parameters[:name])
    end

    it "should render a json representation of the account" do
      put :update, id: account, account: updated_parameters, format: "json"
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end

    it "should render a 400 error on failure" do
      put :update, id: account, account: { name: "" }

      expect(response.status).to eq(400)
    end
  end

  describe "DELETE #destroy" do
    it "should destroy the specified account" do
      delete :destroy, id: account, format: "json"

      expect(Account.count).to eq(0)
    end

    it "should render a json representation of the deleted account" do
      delete :destroy, id: account, format: "json"
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end

    it 'should render a 400 error on failure' do
      allow_any_instance_of(Account).to receive(:destroy).and_return(false)
      delete :destroy, id: account, format: "json"

      expect(response.status).to eq(400)
    end
  end
end
