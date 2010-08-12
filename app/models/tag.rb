class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :pics, :through => :taggings
  
  named_scope :ordered_by_taggings, :joins => :taggings, :group => "tags.id, tags.name, tags.created_at, tags.updated_at", :order => 'count(taggings.id) desc' 
  named_scope :limit, lambda { |num| { :limit => num} } 
  
end
