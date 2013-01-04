require 'spec_helper'

describe Account do
  let(:account) { FactoryGirl.create(:account) }

  describe 'associations' do
    it { should have_and_belong_to_many(:users) }
    it { should have_many(:entries) }
    it { should have_many(:invitations) }
    it { should have_many(:recurring_transactions) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:balance) }
  end

  describe 'callbacks' do
    describe 'after_create' do
      it 'should convert the inital_balance string to an integer' do
        account = FactoryGirl.create(:account, :initial_balance => "$12.34")
        account.reload
        expect(account.balance).to eq(1234)
      end

      it 'should convert a complex inital_balance string to an integer' do
        account = FactoryGirl.create(:account, :initial_balance => "$1,234,567.89")
        account.reload
        expect(account.balance).to eq(123456789)
      end
    end
  end

  describe '#to_param' do
    it 'should return the slug of the account' do
      expect(account.to_param).to eq(account.url)
    end
  end

  describe '#dollar_balance' do
    it 'should convert the integer to a correct dollar value' do
      account = FactoryGirl.create(:account, :balance => 4735)
      expect(account.dollar_balance).to eq("$47.35")
    end

    it 'should convert a complex integer to a correct dollar balance' do
      account = FactoryGirl.create(:account, :balance => 123456789)
      expect(account.dollar_balance).to eq("$1,234,567.89")
    end
  end
end
