class Mhash < ActiveRecord::Base
  attr_accessible :signed, :unsigned, :user_id
  belongs_to :user
end
