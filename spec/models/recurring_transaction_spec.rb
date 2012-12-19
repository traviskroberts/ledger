require 'spec_helper'

describe RecurringTransaction do
  describe 'associations' do
    it { should belong_to(:account) }
  end

  describe 'validations' do
    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
    it { should validate_presence_of(:classification) }
    it { should ensure_inclusion_of(:classification).in_array(['credit', 'debit']) }
    it { should validate_presence_of(:day) }
    it { should validate_numericality_of(:day) }
    it { should validate_presence_of(:float_amount) }
  end

  describe 'callbacks' do
    describe 'before_validation(:on => :create)' do
      it 'should set the classification to credit if amount is positive' do
        recurring_transaction = FactoryGirl.create(:recurring_transaction, :float_amount => '12.34')
        expect(recurring_transaction.classification).to eq('credit')
      end

      it 'should set the classification to debit if amount is negative' do
        recurring_transaction = FactoryGirl.create(:recurring_transaction, :float_amount => '-12.34')
        expect(recurring_transaction.classification).to eq('debit')
      end

      it 'should set the amount to an integer version of a positive float_amount' do
        recurring_transaction = FactoryGirl.create(:recurring_transaction, :float_amount => '123.45')
        expect(recurring_transaction.amount).to eq(12345)
      end

      it 'should set the amount to an integer version of a negative float_amount' do
        recurring_transaction = FactoryGirl.create(:recurring_transaction, :float_amount => '-123.45')
        expect(recurring_transaction.amount).to eq(12345)
      end
    end
  end

  describe '#dollar_amount' do
    it 'should return a float' do
      recurring_transaction = FactoryGirl.create(:recurring_transaction)
      expect(recurring_transaction.dollar_amount.class).to eq(Float)
    end

    it 'should convert the integer to a correct dollar amount' do
      recurring_transaction = FactoryGirl.create(:recurring_transaction, :float_amount => "47.35")
      expect(recurring_transaction.dollar_amount).to eq(47.35)
    end

    it 'should convert a complex integer to a correct dollar amount' do
      recurring_transaction = FactoryGirl.create(:recurring_transaction, :float_amount => "1,234,567.89")
      expect(recurring_transaction.dollar_amount).to eq(1234567.89)
    end
  end
end
