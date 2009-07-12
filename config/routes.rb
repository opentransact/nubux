ActionController::Routing::Routes.draw do |map|
  map.resources :oauth_clients,:transacts
  
  map.authorize '/oauth/authorize',:controller=>'oauth',:action=>'authorize'
  map.request_token '/oauth/request_token',:controller=>'oauth',:action=>'request_token'
  map.access_token '/oauth/access_token',:controller=>'oauth',:action=>'access_token'
  map.test_request '/oauth/test_request',:controller=>'oauth',:action=>'test_request'
  
  map.root :controller=>'welcome'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
