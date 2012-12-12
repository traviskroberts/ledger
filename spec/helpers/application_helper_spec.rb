require 'spec_helper'

describe ApplicationHelper do
  describe '#formatted_amount' do
    it 'should return a negative dollar amount if it is a debit' do
      helper.formatted_amount(123.45, 'debit').should == '-$123.45'
    end

    it 'should return a dollar amount if it is a credit' do
      helper.formatted_amount(1234567.89, 'credit').should == '$1,234,567.89'
    end
  end
end
