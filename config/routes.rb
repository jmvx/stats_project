Rails.application.routes.draw do
  root 'records#index'
  get '/top_urls' => 'records#top_urls'
  get '/top_referrers' => 'records#top_referrers'
  get '/get_top_urls' => 'records#get_top_urls'
  get '/get_top_referrers' => 'records#get_top_referrers'
  resources 'records'
end
