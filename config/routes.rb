Rails.application.routes.draw do
  post '/', to: 'github_events#webhook'
end