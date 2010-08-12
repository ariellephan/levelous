class Quest < ActiveRecord::Base
  has_many :completed_quests
  has_many :users, :through => :completed_quests
   
  def completed?(user)
    count = 0
    if self.title == "Organ Donor"
      count = Heart.count(:all, :conditions => {:user_id => user.id})
    elsif self.title == "Popularity Contest" || self.title == 'Well Known' || self.title == 'Superstar'
      count = Friendship.count(:all, :conditions => {:friend_id => user.id})
    elsif self.title == 'Contribute' || self.title == 'Hooked'
      count = user.pics.count
    elsif self.title == 'Daily Login' || self.title == 'Committed'
      count = user.consecutive_login_days
    elsif self.title == 'Leveler' || self.title == 'Levelest'
      count = user.completed_quests.count
    elsif self.title == 'Karma' || self.title == 'Skills' || self.title == 'Pro'
      user.pics.each do |pic|
        count += pic.hearts.count
      end 
    elsif self.title == 'Conquistador'
       user.pics_hearted.each do |hearted_pic|
         first_heart = Heart.find(:first, :conditions => {:pic_id => hearted_pic.id}, :order => 'created_at')
         if first_heart.user_id == user.id
           count += 1
         end 
       end
    elsif self.title == 'Hot Pic' || self.title == 'True Love' || self.title == 'Masterpiece'
      user.pics.each do |pic|
        heart_count = pic.hearts.count
        if heart_count > count
          count = pic.hearts.count
        end
        if count >= self.count_required
          return true
        end
      end
    elsif self.title == 'Eyecatcher' || self.title == 'Paparazzi' || self.title == 'Widely Known'
      user.pics.each do |pic|
        heart_count = pic.hearts.count
        if heart_count > count
          count = pic.hearts.count
        end
        if count >= self.count_required
          return true
        end
      end  
    elsif self.title == 'Noteworthy'  
      user.pics.each do |pic|
        comment_count = Comment.find(:all, :conditions => ["pic_id = ? AND user_id IS NOT ?", "#{pic.id}", "#{user.id}"]).count
        if comment_count > count
          count = comment_count
        end
        if count >= self.count_required
          return true
        end
      end
    elsif self.title == 'Props'  
        user.pics_hearted.each do |pic|
          comments_count = Comment.find(:all, :conditions => {:pic_id => pic.id, :user_id => user.id}).count
          if comment_count > 0
            count += 1
          end
          if count >= self.count_required
            return true
          end
        end 
    elsif self.title == 'Go Postal'  
        user.posts.each do |post|
          if post.author_id != user.id
            count += 1
          end
          if count >= self.count_required
            return true
          end
        end
    elsif self.title == 'Flash Flood' || self.title = 'Invasion'
      user.pics.each do |pic|
        pic.hearts.each do |heart|
          if (heart.created_at - pic.created_at) < 1.hour
            count += 1
          end
        end
        if count >= self.count_required
          return true
        else
          count = 0
        end
      end
    elsif self.title == 'Gossip' || self.title = 'Talk of the Town'
      user.pics.each do |pic|
        pic.comments.each do |comment|
          if (comment.created_at - pic.created_at) < 1.hour
            count += 1
          end
        end
        if count >= self.count_required
          return true
        else
          count = 0
        end
      end
    elsif self.title == 'Tagfest'
      user.pics.each do |pic|
        pic.taggings.each do |tag|
          if tag.user_id != user.id
            count += 1
          end
        end
        if count >= self.count_required
          return true
        else
          count = 0
        end
      end 
    elsif self.title == 'Celebrity'
      if user.friendships.count == 0
        return false
      end
      count = Friendship.find(:all, :conditions=> {:friend_id => user.id}).count
      if count > user.friendships.count*10
        return true
      else
        return false
      end
    else
      return false
    end
    return count >= self.count_required
  end
  
  def complete(user)
    if self.completed?(user)
      user.hearts_left += self.hearts_awarded
      user.reputation += self.reputation_awarded
      user.save
      completed_quest = CompletedQuest.new
      completed_quest.user_id = user.id
      completed_quest.quest_id = self.id
      completed_quest.save
    end
  end

end
