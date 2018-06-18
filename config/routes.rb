Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope 'api' do
    resources :users, :only =>[:create]
    resources :wallets, :only =>[:create] do 
      get ':email/', to: 'wallets#list', on: :collection,constraints: { email: /[^\/]+/}
    end
    resources :transactions, :only =>[:create]
    resources :financial_summary, :only => [] do
      get 'display', to: 'financial_summary#display', on: :collection
    end
  end
end
