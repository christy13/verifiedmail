Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "171110006314660", "3d90204c65fbc578d3805ebae2385657"
end