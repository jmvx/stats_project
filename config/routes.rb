Rails.application.routes.draw do
  get 'records/new'
  get 'top_urls' => 'records#show'
  resources 'records'
end
