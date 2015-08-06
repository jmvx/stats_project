Rails.application.routes.draw do
  root 'records#index'
  get 'records/new'
  resources 'records'
end
