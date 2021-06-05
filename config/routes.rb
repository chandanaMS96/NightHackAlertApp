Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/team/developers' => 'developers#create'
      post '/notify/developer' => 'developers#notify'
    end
  end
end
# http://localhost:3000//api/v1/team/developers
# http://localhost:3000//api/v1/notify/developer
