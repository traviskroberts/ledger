class SiteMailer < ActionMailer::Base
  include Sidekiq::Mailer

  def invitation(invite)
    @user = invite.user
    @account = invite.account
    @invitation = invite
    mail(:to => invite.email, :from => @user.email, :subject => 'Invitatation to collaborate on [sitename].')
  end

end
