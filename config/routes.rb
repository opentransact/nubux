ActionController::Routing::Routes.draw do |map|

  map.test_request '/oauth/test_request', :controller => 'oauth', :action => 'test_request'
  map.access_token '/oauth/access_token', :controller => 'oauth', :action => 'access_token'
  map.request_token '/oauth/request_token', :controller => 'oauth', :action => 'request_token'
  map.authorize '/oauth/authorize', :controller => 'oauth', :action => 'authorize'
  map.oauth '/oauth', :controller => 'oauth', :action => 'index'

  map.resources :oauth_clients,:transacts
  
  map.root :controller=>'welcome'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
