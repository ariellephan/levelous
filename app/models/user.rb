class User < ActiveRecord::Base
    acts_as_authentic
    
    #has_attached_file :avatar, :styles => { :regular => "100x100#" }, :default_url => '/images/defaultpic.png'
    has_attached_file :avatar, 
           :storage => :s3, 
           :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
           :path => ":attachment/:id/:style.:extension",
           :styles => {
             :original => "600x600>",
             :thumb => "100x100#",
             :mini => "60x60#",
             :micro => "30x30#"
           },
           :default_url => '/images/default/:style/defaultpic.png'
    
    validates_attachment_content_type :avatar, :content_type=>['image/jpeg','image/pjpeg','image/png','image/x-png'], :message=>'Uploads must be .jpeg or .png'
    validates_attachment_size :avatar, :less_than => 2.megabytes, :message=>'Uploads must be 2 megabytes or smaller'       
    
    
 
    validates_uniqueness_of :login
    validates_uniqueness_of :email
    
    validates_size_of :login, :within => 5..15
    validates_format_of :login, :with => /^\w+$/i, :message => "login names can only contain letters and numbers."
        
  
# pics
    has_many :pics, :dependent => :destroy
# hearting join table (hearts given to other users pics)
    has_many :hearts, :dependent => :destroy
# pics hearted  pics that this user has hearted
    has_many :pics_hearted, :through => :hearts, :source => :pic
# friendships
    has_many :friends, :through => :friendships
    has_many :friendships, :dependent => :destroy
# comments
    has_many :comments
# wall posts
    has_many :posts
# completed quests
    has_many :completed_quests
    has_many :quests, :through => :completed_quests
# tags
    has_many :taggings
    has_many :tags, :through => :taggings
# notifications
    has_many :notifications
    
# named scopes    
    named_scope :limit, lambda { |num| { :limit => num} } 
    
    
    def self.get_leaderboard(pg)     
      if pg == 1
        return User.all(:order=> "reputation DESC", :conditions => {:active => 'true'}, :limit => 20)
      else
        return User.all(:order=> "reputation DESC", :conditions => {:active => 'true'}, :limit => 20, :offset => (20*(pg-1)))
      end   
    end
    
    def self.more_leaderboard_left?(pg)
      return User.count(:conditions => {:active => 'true'}) > (20*pg)      
    end
    
    def active?
      active
    end
    
    def activate!
      self.active = true
      save
    end
    
    def deliver_activation_instructions!
      reset_perishable_token!
      Notifier.deliver_activation_instructions(self)
    end

    def deliver_activation_confirmation!
      reset_perishable_token!
      Notifier.deliver_activation_confirmation(self)
    end
    
    
    
    def increment_reputation
      self.reputation += 1  
      if reputation < 200
        self.level = 1
      elsif reputation < 400
          self.level = 2
      elsif reputation < 650
          self.level = 3
      elsif reputation < 1000
          self.level = 4
      elsif reputation < 1400
          self.level = 5
      elsif reputation < 2000
          self.level = 6
      elsif reputation < 2800
          self.level = 7
      elsif reputation < 3800
          self.level = 8 
      elsif reputation < 5300
          self.level = 9
      elsif reputation < 7500
          self.level = 10
      elsif reputation < 11700
          self.level = 11
      elsif reputation < 17550
          self.level = 12
      elsif reputation < 26300
          self.level = 13
      elsif reputation < 39500
          self.level = 14
      elsif reputation < 59200
          self.level = 15
      elsif reputation < 88500
          self.level = 16
      elsif reputation < 133720
          self.level = 17
      elsif reputation < 199900
          self.level = 18 
      elsif reputation < 299858
          self.level = 19                                    
      elsif reputation < 449800
          self.level = 20
      elsif reputation < 674700
          self.level = 21
      elsif reputation < 1012050
          self.level = 22
      elsif reputation < 1518075
          self.level = 23
      elsif reputation < 2277110
          self.level = 24
      else
          self.level = 25
      end
    end
  
    def owns_pic?(pic)
      if pic.user == self
        return true
      else
        return false
      end
    end
    
    def heart_pic(pic)
       if self.hearts_left > 0
          heart = Heart.new
          heart.user_id = self.id
          heart.pic_id = pic.id
          if heart.save
            self.hearts_left -= 1
            #owner's rep +1
            owner = pic.user
            owner.increment_reputation
            owner.save
            #previous hearters' rep +1 for each heart they awarded the pic      
            pic.hearts.each do |heart|
              if heart.user != self  
                heart.user.increment_reputation
                heart.user.save
              end
            end
            if self.save
              return 0 #flash[:notice] = "Pic hearted."
            else
              return 1 #flash[:notice] = "Error hearting pic."
            end
          else
            return 1 #flash[:notice] = "Error hearting pic."
          end
        else
          return 2 #flash[:notice] = "You have no hearts left to give."
        end
    end
end
