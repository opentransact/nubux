# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def widel_account(user)
    mail_to user.email,user.email,{:class=>'widel-account'}
  end
end
