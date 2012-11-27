class User < ActiveRecord::Base
  has_many :accounts

  attr_accessible :email, :password, :password_confirmation

  acts_as_authentic do |c|
    # because RSpec has problems with Authlogic's session maintenance
    # see https://github.com/binarylogic/authlogic/issues/262#issuecomment-1804988
    c.maintain_sessions = false
  end
end
