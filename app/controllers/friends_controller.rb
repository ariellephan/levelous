class FriendsController < ApplicationController
  before_filter :require_user, :except => [:following, :followers, :show]

  def following
    @user = User.find(params[:id])
    @following = @user.friends
  end
  
  def followers
     @user = User.find(params[:id])
     @followers = Friendship.find(:all, :conditions => {:friend_id => @user.id}, :include => :user )
   end

  def show
    redirect_to user_path(params[:id])
  end

  def new
    @friendship = Friendship.new
  end

  def create
    @user = current_user
    @friend = User.find(params[:id])
    params[:friendship] = {:user_id => @user.id, :friend_id => @friend.id }
    @friendship = Friendship.create(params[:friendship])
    if @friendship.save
      Notification.create(:user_id=>@friend.id, :notification_type=>"follower", :object_id=>@user.id)
      redirect_to :back
    else
      redirect_to user_path(current_user)
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @friend = User.find(params[:id])
    @friendship = @user.friendships.find_by_friend_id(params[:id]).destroy
    redirect_to :back
  end

end
