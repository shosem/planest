Rails.application.routes.draw do
  devise_for :users, controllers: {
        registrations: "users/registrations"
      }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"

  # shallowをtrueにすると、グループの情報が不要なアクションは親が省略される
  # new なんのグループに作る？ → グループ情報が必要 → groups/:group_id/tasks/:id
  # edit → 対象のタスクが取得できれば編集できる → グループ情報は不要 /tasks/:id/edit
  resources :groups, only: %i[ new create show destroy ], shallow: true do
    resources :tasks
  end
  get "auth-demo", to: "pages#auth_demo", as: :auth_demo
  get "group-detail-demo", to: "pages#group_detail_demo", as: :group_detail_demo
  get "join_demo", to: "pages#join_demo", as: :join_demo
  get "join/:invite_code", to: "group_members#new", as: :join
  post "join/:invite_code", to: "group_members#create"
end
