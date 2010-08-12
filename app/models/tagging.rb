class Tagging < ActiveRecord::Base
  belongs_to :pic
  belongs_to :tag
  belongs_to :user
  
end
