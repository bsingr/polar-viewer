Rails.application.routes.draw do
  root "calendar#index"
  get "/calendar", to: "calendar#index"

  get "/training/:date/:time", to: "training#details"
end
