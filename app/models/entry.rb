class Entry < ActiveRecord::Base
  belongs_to :account

  attr_accessible :account_id, :amount, :classification, :description

  validates :account, :presence => true
  validates :amount, :presence => true, :numericality => true
  validates :classification, :presence => true, :inclusion => { :in => %w(credit debit) }

  before_save :convert_amount

  def dollar_amount
    amount.to_f / 100
  end

  private
    def convert_amount
      self.amount = (amount * 100).to_i
    end
end
