class User < ActiveRecord::Base
  attr_accessible :crypted_password, :current_login_at, :current_login_ip, :email, :last_login_at, :last_login_ip, :last_request_at, :login_count, :password_salt, :perishable_token, :persistence_token

  acts_as_authentic do |c|
    # because RSpec has problems with Authlogic's session maintenance
    # see https://github.com/binarylogic/authlogic/issues/262#issuecomment-1804988
    c.maintain_sessions = false
  end
end
