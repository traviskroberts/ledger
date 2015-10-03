require "rails_helper"

describe Api::RecurringTransactionsController do
  let(:user) { create(:user) }
  let(:account) { create(:account, url: "test-account", users: [user]) }
  let(:recurring_transaction) { create(:recurring_transaction, account: account) }

  before :each do
    allow(controller).to receive(:current_user) { user }
  end

  describe "GET #index" do
    let!(:recurring_transaction) { create(:recurring_transaction, account: account) }

    it "should get a list of current recurring transactions" do
      get :index, account_id: account

      expect(assigns(:recurring_transactions)).to eq([recurring_transaction])
    end

    it "should render a json representation of the recurring transactions" do
      get :index, account_id: account
      jsr = JSON.parse(response.body, symbolize_names: true)
      expect(jsr.first.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end
  end

  describe "POST #create" do
    it "should create a new recurring transaction" do
      post :create, account_id: account, recurring_transaction: { day: 1, float_amount: 14.52 }

      expect(account.recurring_transactions.count).to eq(1)
    end

    it "should render a json representation of the created recurring transaction" do
      post :create, account_id: account, recurring_transaction: { day: 1, float_amount: 14.52 }
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end

    it "should render a 400 status on error" do
      post :create, account_id: account, recurring_transaction: {}

      expect(response.status).to eq(400)
    end
  end

  describe "PUT #update" do
    let(:update_params) { {day: "15", float_amount: "45.41"} }

    it "should update the recurring transaction attributes" do
      put :update, account_id: account, id: recurring_transaction, recurring_transaction: update_params

      expect(recurring_transaction.reload.day).to eq(15)
    end

    it "render a json representation of the updated recurring transaction" do
      put :update, account_id: account, id: recurring_transaction, recurring_transaction: update_params
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end

    it "should return a 400 status on failure" do
      put :update, account_id: account, id: recurring_transaction, recurring_transaction: {}

      expect(response.status).to eq(400)
    end
  end

  describe "DELETE #destroy" do
    it "should destroy the recurring transaction" do
      delete :destroy, account_id: account, id: recurring_transaction

      expect(account.recurring_transactions.count).to eq(0)
    end

    it "render a json representation of the deleted recurring transaction" do
      delete :destroy, account_id: account, id: recurring_transaction
      jsr = JSON.parse(response.body, symbolize_names: true)

      expect(jsr.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end

    it "should return a 400 status on failure" do
      allow_any_instance_of(RecurringTransaction).to receive(:destroy).and_return(false)
      delete :destroy, account_id: account, id: recurring_transaction

      expect(response.status).to eq(400)
    end
  end
end
