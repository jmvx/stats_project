Rails.application.routes.draw do
  root 'records#index'
  get 'records/new'
  get '/top_urls' => 'records#top_urls'
  get '/top_referrers' => 'records#top_referrers'
  
  resources 'records'
end
