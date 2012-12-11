require 'spec_helper'

describe Entry do
  describe 'associations' do
    it { should belong_to(:account) }
  end

  describe 'validations' do
    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
    it { should validate_presence_of(:classification) }
    it { should ensure_inclusion_of(:classification).in_array(['credit', 'debit']) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:float_amount) }
  end

  describe 'callbacks' do
    describe 'before_validation(:on => :create)' do
      it 'should set the classification to credit if amount is positive' do
        entry = FactoryGirl.create(:entry, :float_amount => '12.34')
        expect(entry.classification).to eq('credit')
      end

      it 'should set the classification to debid if amount is negative' do
        entry = FactoryGirl.create(:entry, :float_amount => '-12.34')
        expect(entry.classification).to eq('debit')
      end

      it 'should set the amount to an integer version of a positive float_amount' do
        entry = FactoryGirl.create(:entry, :float_amount => '123.45')
        expect(entry.amount).to eq(12345)
      end

      it 'should set the amount to an integer version of a negative float_amount' do
        entry = FactoryGirl.create(:entry, :float_amount => '-12.34')
        expect(entry.amount).to eq(1234)
      end
    end

    describe 'after_save' do
      it 'should update the account balance by adding a credit entry' do
        entry = FactoryGirl.create(:entry, :float_amount => '12.34')
        expect(entry.account.balance).to eq(1234)
      end

      it 'should update the account balance by subtracting a debit entry' do
        account = FactoryGirl.create(:account, :initial_balance => '$20.00')
        account.reload
        entry = FactoryGirl.create(:entry, :account => account, :float_amount => '-12.34')
        expect(account.balance).to eq(766)
      end
    end

    describe 'after_destroy' do
      it 'should add a deleted debit entry back to the account' do
        account = FactoryGirl.create(:account, :initial_balance => '$20.00')
        account.reload
        entry = FactoryGirl.create(:entry, :account => account, :float_amount => '-12.34')
        entry.destroy
        expect(account.balance).to eq(2000)
      end

      it 'should subtract a deleted credit entry back from the account' do
        account = FactoryGirl.create(:account, :initial_balance => '$20.00')
        account.reload
        entry = FactoryGirl.create(:entry, :account => account, :float_amount => '12.34')
        entry.destroy
        expect(account.balance).to eq(2000)
      end
    end
  end

  describe '#dollar_amount' do
    it 'should return a float' do
      entry = FactoryGirl.create(:entry)
      expect(entry.dollar_amount.class).to eq(Float)
    end

    it 'should convert the integer to a correct dollar amount' do
      entry = FactoryGirl.create(:entry, :float_amount => "47.35")
      expect(entry.dollar_amount).to eq(47.35)
    end

    it 'should convert a complex integer to a correct dollar amount' do
      entry = FactoryGirl.create(:entry, :float_amount => "1,234,567.89")
      expect(entry.dollar_amount).to eq(1234567.89)
    end
  end

  describe '#credit?' do
    it 'should return true if the classification is credit' do
      entry = FactoryGirl.build(:entry, :classification => 'credit')
      expect(entry.credit?).to eq(true)
    end

    it 'should return false if the classification is debit' do
      entry = FactoryGirl.build(:entry, :classification => 'debit')
      expect(entry.credit?).to eq(false)
    end
  end

  describe '#debit?' do
    it 'should return true if the classification is credit' do
      entry = FactoryGirl.build(:entry, :classification => 'debit')
      expect(entry.debit?).to eq(true)
    end

    it 'should return false if the classification is debit' do
      entry = FactoryGirl.build(:entry, :classification => 'credit')
      expect(entry.debit?).to eq(false)
    end
  end
end
