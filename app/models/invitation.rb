class Invitation < ActiveRecord::Base
  belongs_to :account
  belongs_to :user

  attr_accessible :email, :token

  validates :account, :presence => true
  validates :email, :presence => true
  validates :token, :presence => true
  validates :user, :presence => true

  delegate :url, to: :account, prefix: true

  def as_json(options={})
    opts = {
      only: [:id, :account_id, :user_id, :email, :token],
      methods: [:account_url]
    }

    super(options.merge(opts))
  end
end
