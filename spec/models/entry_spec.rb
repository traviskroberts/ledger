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

      it 'should set the classification to debit if amount is negative' do
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

    describe 'after_update' do
      before :each do
        @account = FactoryGirl.create(:account, :initial_balance => '100.00')
        @account.reload
      end

      it 'should correct the account balance if the credit is greater than the previous amount' do
        entry = FactoryGirl.create(:entry, :account => @account, :float_amount => '10.00')
        entry.update_attributes(:float_amount => '15.00')
        expect(@account.reload.balance).to eq(11500)
      end

      it 'should correct the account balance if the credit is less than the previous amount' do
        entry = FactoryGirl.create(:entry, :account => @account, :float_amount => '10.00')
        entry.update_attributes(:float_amount => '5.00')
        expect(@account.reload.balance).to eq(10500)
      end

      it 'should correct the account balance if the debit is greater than the previous amount' do
        entry = FactoryGirl.create(:entry, :account => @account, :float_amount => '-10.00')
        entry.update_attributes(:float_amount => '-15.00')
        expect(@account.reload.balance).to eq(8500)
      end

      it 'should correct the account balance if the debit is less than the previous amount' do
        entry = FactoryGirl.create(:entry, :account => @account, :float_amount => '-10.00')
        entry.update_attributes(:float_amount => '-5.00')
        expect(@account.reload.balance).to eq(9500)
      end

      it 'should correct the account balance if the entry was changed from credit to debit' do
        entry = FactoryGirl.create(:entry, :account => @account, :float_amount => '10.00')
        entry.update_attributes(:float_amount => '-10.00')
        expect(@account.reload.balance).to eq(9000)
      end

      it 'should correct the account balance if the entry was changed from debit to credit' do
        entry = FactoryGirl.create(:entry, :account => @account, :float_amount => '-10.00')
        entry.update_attributes(:float_amount => '10.00')
        expect(@account.reload.balance).to eq(11000)
      end

      it 'should correct the account balance if the entry was changed from credit to debit and the ammount changed' do
        entry = FactoryGirl.create(:entry, :account => @account, :float_amount => '10.00')
        entry.update_attributes(:float_amount => '-15.00')
        expect(@account.reload.balance).to eq(8500)
      end

      it 'should correct the account balance if the entry was changed from debit to credit and the ammount changed' do
        entry = FactoryGirl.create(:entry, :account => @account, :float_amount => '-10.00')
        entry.update_attributes(:float_amount => '15.00')
        expect(@account.reload.balance).to eq(11500)
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

  describe '#as_json' do
    it 'json representation should only include the specified fields' do
      entry = FactoryGirl.create(:entry)
      json = JSON.parse(entry.to_json, :symbolize_names => true)
      expect(json.keys).to match_array([:id, :classification, :description, :formatted_amount, :date, :timestamp])
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

  describe '#formatted_amount' do
    it 'should return a positive formatted dollar representation of the dollar amount if it is a credit' do
      entry = FactoryGirl.create(:entry, :classification => 'credit', :float_amount => '59')
      expect(entry.formatted_amount).to eq("$59.00")
    end

    it 'should return a negative formatted dollar representation of the dollar amount if it is a debit' do
      entry = FactoryGirl.create(:entry, :classification => 'debit', :float_amount => '-14.2')
      expect(entry.formatted_amount).to eq("-$14.20")
    end
  end

  describe '#date' do
    it 'should return a formatted representation of the created_at date' do
      entry = FactoryGirl.create(:entry, :classification => 'credit', :float_amount => '59')

      expect(entry.date).to eq(entry.created_at.strftime("%m/%d/%Y"))
    end
  end

  describe '#timestamp' do
    it 'should return a Fixnum unix timestamp for the entry' do
      entry = FactoryGirl.create(:entry)
      expect(entry.timestamp.class).to eq(Fixnum)
    end

    it 'should return the correct unix timestamp for the entry' do
      entry = FactoryGirl.create(:entry, :created_at => '2001-03-08')
      expect(entry.timestamp).to eq(984009600)
    end
  end
end
