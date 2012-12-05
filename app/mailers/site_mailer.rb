class SiteMailer < ActionMailer::Base

  def invitation(invite)
    @user = invite.user
    @account = invite.account
    mail(:to => invite.email, :from => @user.email, :subject => 'Invitatation to collaborate on [sitename].')
  end

end
