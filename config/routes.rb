Rails.application.routes.draw do
  post 'callback', to: 'line_bot#callback'

  get 'chat', to: 'gpt#chat'
end
