class Rsakey < ActiveRecord::Base
  attr_accessible :e_private_key, :public_key, :user_id
  belongs_to :user
end
