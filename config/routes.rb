require 'sidekiq/web'

Rails.application.routes.draw do
  resources :articles
  resources :users
  resources :posts
scope :monitoring do
# PGHero Basic Auth from routes on production environment
mount PgHero::Engine, at: 'pgdashboard'


# Sidekiq Basic Auth from routes on production environment
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['sidekiq_username'])) &
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['sidekiq_password']))
end

mount Sidekiq::Web => '/sidekiq'


end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
