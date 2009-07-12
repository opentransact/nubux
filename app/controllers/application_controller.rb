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

  alias_method :login_required, :authenticate
  
  # To make clearance work with oauth_plugin
  def current_user
    @current_user ||= super
  end
  
  def authorized?
    true
  end
end
