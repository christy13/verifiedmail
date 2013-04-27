OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 171110006314660, "4b977ea125e39c309ede9fad31ece943" #ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
end