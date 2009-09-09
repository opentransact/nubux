# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  alias_method :logged_in?, :signed_in?

  helper_method :logged_in?
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  protected 
  
  # Hack for it to work with clearance
  def current_token=(token)
    @current_token=token
    if @current_token
      @current_user=@_current_user=@current_token.user
      @current_client_application=@current_token.client_application 
    end
    @current_token
  end
  
  alias_method :login_required, :authenticate
  
  # To make clearance work with oauth_plugin
#  def current_user
#    @current_user ||= super
#  end
  
  def authorized?
    true
  end
end
