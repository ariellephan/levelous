class Pic < ActiveRecord::Base
  #has_attached_file :photo, :styles => { :small => "200x200#", :regular => "500x500>"}
  has_attached_file :photo, 
        :storage => :s3, 
        :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
        :path => ":attachment/:id/:style.:extension",
        :styles => {
          :medium => "600x600>",
          :thumb => "100x100#"
        }
   
  validates_attachment_content_type :photo, :content_type=>['image/jpeg','image/pjpeg','image/png','image/x-png'], :message=>'Uploads must be .jpeg or .png'
  validates_attachment_size :photo, :less_than => 2.megabytes, :message=>'Uploads must be 2 megabytes or smaller'       
         
  #constants
  INDEX_PIC_PG_SIZE = 20
  USER_PIC_PG_SIZE = 9
  
  belongs_to :user
  has_many :comments
  has_many :hearts, :dependent => :destroy
  has_many :hearters, :through => :hearts, :source => :user
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  #named scopes  
  named_scope :ordered_by_hearts, :joins => :hearts, :group => "pics.id, pics.title, pics.description, pics.user_id, pics.created_at, pics.updated_at, pics.photo_file_name, pics.photo_content_type, pics.photo_file_size, pics.photo_updated_at, pics.view_count", :order => 'count(hearts.id) desc' 
  named_scope :ordered_by_hearts_today, :joins => :hearts, :conditions => ['hearts.created_at > ?', 1.day.ago ], :group => "pics.id, pics.title, pics.description, pics.user_id, pics.created_at, pics.updated_at, pics.photo_file_name, pics.photo_content_type, pics.photo_file_size, pics.photo_updated_at, pics.view_count", :order => 'count(hearts.id) desc' 
  named_scope :limit, lambda { |num| { :limit => num} } 
  named_scope :offset, lambda { |num| { :offset => num} }   
  
  validates_presence_of :user_id, :on => :create, :message => "You must be logged in to do that"
  validates_attachment_presence :photo
  # validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png'], :message => 'can only be jpeg and png.'
  #  validates_attachment_size :photo, :less_than => 2.megabytes
  
  def self.get_next(pic)
    next_pic = Pic.find(:all, :limit => 1, :conditions =>['id > ? and user_id = ?', pic.id, pic.user_id ], :order => 'id') 
    if next_pic.size == 0
      next_pic = Pic.find(:all, :limit => 1, :conditions =>['user_id = ?', pic.user_id ], :order => 'id') 
    end
    return next_pic
  end
  
  def self.search(search, pg)
    if search
      pics = Pic.find(:all,:order=>'created_at DESC', :limit => Pic::INDEX_PIC_PG_SIZE, :conditions => ['lower(title) LIKE :s or lower(description) LIKE :s', {:s => "%#{search}%"} ])
      tags = Tag.find(:all, :order=>'created_at DESC', :limit => Pic::INDEX_PIC_PG_SIZE, :conditions => ['lower(name) LIKE :s', {:s => "%#{search}%"} ])
      tags.each do |tag|
        tag.pics.each do |tag_pic|
          unless pics.include?(tag_pic)
            pics << tag_pic
          end
        end
      end
      return pics[(Pic::INDEX_PIC_PG_SIZE*(pg-1)), Pic::INDEX_PIC_PG_SIZE]
    else
      Pic.find(:all, :order=>'created_at DESC', :limit => Pic::INDEX_PIC_PG_SIZE, :offset => (Pic::INDEX_PIC_PG_SIZE*(pg-1)))
    end
  end
  
  def self.more_search_pics_left?(search, pg)
     if search
        pics = Pic.find(:all,:order=>'created_at DESC', :limit => Pic::INDEX_PIC_PG_SIZE, :conditions => ['lower(title) LIKE :s or lower(description) LIKE :s', {:s => "%#{search}%"} ])
        tags = Tag.find(:all, :order=>'created_at DESC', :limit => Pic::INDEX_PIC_PG_SIZE, :conditions => ['lower(name) LIKE :s', {:s => "%#{search}%"} ])
        tags.each do |tag|
          tag.pics.each do |tag_pic|
            unless pics.include?(tag_pic)
              pics << tag_pic
            end
          end
        end
        return  pics.size > (Pic::INDEX_PIC_PG_SIZE*pg)
     else
        return  Pic.count > (Pic::INDEX_PIC_PG_SIZE*pg)
     end   
  end
  
  def self.get_pics(pg, category)
    if category == 'new'
      if pg == 1
        return Pic.all(:order => 'created_at DESC', :limit => Pic::INDEX_PIC_PG_SIZE)
      else
        return Pic.all(:order => 'created_at DESC', :limit => Pic::INDEX_PIC_PG_SIZE, :offset => (Pic::INDEX_PIC_PG_SIZE*(pg-1)))
      end
    elsif category == 'top'
        if pg == 1
          return Pic.ordered_by_hearts.limit(Pic::INDEX_PIC_PG_SIZE)
        else
          return Pic.ordered_by_hearts.offset(Pic::INDEX_PIC_PG_SIZE*(pg-1)).limit(Pic::INDEX_PIC_PG_SIZE)
        end
    elsif category == 'hot'
        if pg == 1
          return Pic.ordered_by_hearts_today.limit(Pic::INDEX_PIC_PG_SIZE)
        else
          return Pic.ordered_by_hearts_today.offset(Pic::INDEX_PIC_PG_SIZE*(pg-1)).limit(Pic::INDEX_PIC_PG_SIZE)
        end    
    end
  end  
  
  def self.more_pics_left?(pg, category)
     if category == 'new'
       return Pic.count > (Pic::INDEX_PIC_PG_SIZE*pg)
     elsif category == 'top'
       return Pic.ordered_by_hearts.length > (Pic::INDEX_PIC_PG_SIZE*pg)
     elsif category == 'hot'
        return Pic.ordered_by_hearts_today.length > (Pic::INDEX_PIC_PG_SIZE*pg)
     end
  end
  
end
