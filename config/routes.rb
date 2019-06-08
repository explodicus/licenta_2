Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :books
    authenticated :user do
      # get '/:locale' => 'posts#index'
      root 'posts#index'
    end

    # get '/:locale' => 'pages#home'
    root 'pages#home'
    get 'home' => 'pages#home'
    get 'about' => 'pages#about'
    get 'contact' => 'pages#contact'
    get 'help' => 'pages#help'
    get 'academic_program' => 'pages#academic_program'
    get 'toefl' => 'pages#toefl'
    get 'bac' => 'pages#bac'
    get 'performance' => 'pages#performance'
    get 'weekend_school' => 'pages#weekend_school'
    get 'vacation_school' => 'pages#vacation_school'
    get 'getting_ready_for_school' => 'pages#getting_ready'
    get 'international_camps' => 'pages#international_camps'
    get 'uk' => 'pages#uk'
    get 'germany' => 'pages#germany'
    get 'france' => 'pages#france'
    get 'spain' => 'pages#spain'
    get 'study_abroad' => 'pages#study_abroad'

    devise_for :users, :controllers => {:sessions => "users/sessions"}

    devise_scope :user do
      get '/users', to: 'devise/registrations#new'
      get '/users/password', to: 'devise/passwords#new'
      get '/users/admin/sign_in' => 'users/sessions#admin_new'
    end

    resources :users do
      collection do
        get 'students'
        get 'teachers'
        get 'pending_approval'
      end

      member do
        get 'make_admin'
        get 'make_teacher'
        get 'remove_admin'
        get 'remove_teacher'
        get 'make_editor'
        get 'remove_editor'
        get 'approve'
        get 'sign_sb_in'
        get 'set_discount'
        put 'update_discount'
      end
    end

    get 'search_attendance' => 'attendances#search_attendance'
    post 'found_attendance' => 'attendances#found_attendance'
    post 'create_attendance' => 'attendances#create_attendances'

    resources :groups
    resources :posts
    resources :vacations, except: [:show]
    resources :lessons, only: %i[create destroy]
    resources :single_lessons, only: %i[create destroy]

    resources :children, only: %i[create new update] do
      member do
        get 'new_full'
        get 'edit'
        put 'create_full'
      end
    end
  end
end 

