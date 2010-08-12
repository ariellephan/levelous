class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :pic
  
  validates_presence_of :message
  
  # constants
  PG_SIZE = 5
  
end
