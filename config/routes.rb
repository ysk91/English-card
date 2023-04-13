Rails.application.routes.draw do
  post 'callback', to: 'line_bot#callback'

  post 'chat', to: 'gpt#chat'
end
