FACEBOOK_CONFIG = YAML.load_file("#{::Rails.root}/config/facebook.yml")[::Rails.env]
Rails.logger.debug("\n Got to config file!!!")
