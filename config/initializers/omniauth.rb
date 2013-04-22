OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 171110006314660, "3d90204c65fbc578d3805ebae2385657" #ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
end