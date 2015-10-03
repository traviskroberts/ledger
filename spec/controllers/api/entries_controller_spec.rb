require "rails_helper"

describe Api::EntriesController do
  let(:user) { create(:user) }
  let(:account) { create(:account, url: "test-account", users: [user]) }
  let(:entry) { create(:entry, account: account) }
  let(:entries) { create_list(:entry, 2, account: account) }

  before :each do
    allow(controller).to receive(:current_user) { user }
  end

  describe "GET #index" do
    it "should return a json representation of the entries" do
      get :index, account_id: account, format: "json"
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:page, :total_pages, :total_number, :entries])
    end
  end

  describe "POST #create" do
    let(:new_params) {
      {
        float_amount: "1.23",
        description: "lunch",
        date: Date.today.strftime("%Y-%m-%d")
      }
    }

    it "should create an entry for the account" do
      post :create, account_id: account, entry: new_params, format: "json"

      expect(account.entries.count).to eq(2)
    end

    it "should render a json representation of the entry" do
      post :create, account_id: account, entry: new_params, format: "json"
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr[:entry].keys).to match_array([:account_url, :classification, :description, :id, :formatted_amount, :formatted_date, :timestamp, :form_amount_value])
    end

    it "should render a json representation of the updated account balance" do
      post :create, account_id: account, entry: new_params, format: "json"
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to include(:account_balance)
    end

    it "should render a 400 error on failure" do
      post :create, account_id: account, entry: {}, format: "json"

      expect(response.status).to eq(400)
    end
  end

  describe "PUT #update" do
    let(:update_params) {
      {
        float_amount: "-9.17",
        description: "lunch",
        date: Date.today.strftime("%Y-%m-%d")
      }
    }

    it "should update the entry attributes" do
      put :update, { account_id: account, id: entry }.merge(update_params)

      expect(entry.reload.description).to eq(update_params[:description])
    end

    it "should return a json representation of the entry" do
      put :update, { account_id: account, id: entry }.merge(update_params)
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:account_balance, :entry])
    end

    it "should return a 400 status on failure" do
      allow_any_instance_of(Entry).to receive(:update_attributes).and_return(false)
      put :update, { account_id: account, id: entry }.merge(update_params)

      expect(response.status).to eq(400)
    end
  end

  describe "DELETE #destroy" do
    it "should destroy the specified entry" do
      delete :destroy, account_id: account, id: entry, format: "json"

      expect(Entry.count).to eq(1) # initial balance
    end

    it "should return a json representation of the updated account balance" do
      delete :destroy, account_id: account, id: entry, format: "json"
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr[:balance]).to be_present
    end

    it "should return a 400 status on failure" do
      allow_any_instance_of(Entry).to receive(:destroy).and_return(false)
      delete :destroy, account_id: account, id: entry, format: "json"

      expect(response.status).to eq(400)
    end
  end
end
