class ScheduledTransaction < ActiveRecord::Base
  belongs_to :account

  attr_accessible :account_id, :amount, :day

  validates :account, :presence => true
end
