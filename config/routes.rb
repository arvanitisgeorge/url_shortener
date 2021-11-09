Rails.application.routes.draw do
  root "url_provider#index"
  get "/url_providers", to: "url_provider#index"
  get "/url_providers/export_to_csv", to: "url_provider#export_to_csv"
  patch "/url_providers/:id", to: "url_provider#update"
  post "/url_providers/shorten", to: "url_provider#shorten"
end
