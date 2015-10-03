require "rails_helper"

describe ApplicationHelper do
  describe "#formatted_amount" do
    it "should return a negative dollar amount if it is a debit" do
      expect(helper.formatted_amount(123.45, "debit")).to eq("-$123.45")
    end

    it "should return a dollar amount if it is a credit" do
      expect(helper.formatted_amount(1234567.89, "credit")).to eq("$1,234,567.89")
    end
  end
end
