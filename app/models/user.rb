class User < ActiveRecord::Base
  has_and_belongs_to_many :accounts
  has_many :invitations

  attr_accessible :name, :email, :password, :password_confirmation

  acts_as_authentic do |c|
    # because RSpec has problems with Authlogic's session maintenance
    # see https://github.com/binarylogic/authlogic/issues/262#issuecomment-1804988
    c.maintain_sessions = false
  end

  def as_json(options={})
    opts = {:only => [:id, :name, :email]}

    super(options.merge(opts))
  end
end
