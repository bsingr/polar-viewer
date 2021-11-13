Rails.application.routes.draw do
  root "calendar#index"
  get "/calendar", to: "calendar#index"

  get "/training", to: "training#list_dates", as: "training_dates"
  get "/training/:date", to: "training#list_times", as: "training_times"
  get "/training/:date/:time", to: "training#details", as: "training_details"
end
