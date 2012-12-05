class Invitation < ActiveRecord::Base
  belongs_to :account
  belongs_to :user

  attr_accessible :account, :email, :token, :user

  validates :account, :presence => true
  validates :user, :presence => true
  validates :email, :presence => true
  validates :token, :presence => true
end
