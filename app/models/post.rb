class Post < ActiveRecord::Base
  belongs_to :user
  
  #CONSTANTS
  PG_SIZE = 5
  
end
