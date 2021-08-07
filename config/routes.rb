# frozen_string_literal: true

Rails.application.routes.draw do
  jsonapi_resources :activities
  jsonapi_resources :courses
  jsonapi_resources :coaches
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
