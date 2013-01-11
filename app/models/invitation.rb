class Invitation < ActiveRecord::Base
  belongs_to :account
  belongs_to :user

  attr_accessible :email, :token

  validates :account, :presence => true
  validates :user, :presence => true
  validates :email, :presence => true
  validates :token, :presence => true

  def as_json(options={})
    opts = {:only => [:account_id, :user_id, :email, :token]}

    super(options.merge(opts))
  end
end
