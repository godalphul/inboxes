Rails.application.routes.draw do

  resources :discussions, :except => :edit, :module => :inboxes do
    resources :messages, :only => [:create, :index]
    resources :speakers, :only => [:create, :destroy]
    member do
      post 'leave'
    end
    

  end
  
    match 'discussions/:id/addusers', to: "inboxes/discussions#add_users", as: "add_users_to_discussion"

end