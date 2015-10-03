require "rails_helper"

describe InvitationsController do
  let(:user) { create(:user) }
  let(:account) { create(:account, users: [user]) }
  let(:invite) { create(:invitation, account: account, user: user) }

  before :each do
    allow(controller).to receive(:current_user) { user }
  end

  describe "GET #show" do
    context "invitation token is valid" do
      before do
        get :show, token: invite.token
      end

      it "should assign the new user to the account" do
        expect(account.users).to eq([invite.user])
      end

      it "should destroy the invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "should set a flash message" do
        expect(flash[:success]).to be_present
      end

      it "should redirect the user to the home page" do
        expect(response).to redirect_to(root_url)
      end
    end

    context "invitation token is invalid" do
      before do
        get :show, token: "bogustoken"
      end

      it "sets a flash error message" do
        expect(flash[:error]).to be_present
      end

      it "should redirect the user to the home page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
