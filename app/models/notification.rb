class Notification < ActiveRecord::Base
  belongs_to :user

# named scopes    
  named_scope :limit, lambda { |num| { :limit => num} }

end
