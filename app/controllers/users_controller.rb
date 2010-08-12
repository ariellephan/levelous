class UsersController < ApplicationController
    before_filter :require_no_user, :only => [:new, :create]
    before_filter :require_user, :only => [:home, :edit, :update, :post_to_wall, :destroy_post]
    
    def index
     if flash[:leaderboard_pg] == nil || flash[:leaderboard_pg] == 0 || flash[:leaderboard_pg] == flash[:old_pg] || flash[:ajaxed]
        flash[:leaderboard_pg] = 1
      end
      flash[:old_pg] = flash[:leaderboard_pg]
      @users = User.get_leaderboard(flash[:leaderboard_pg])
      if User.more_leaderboard_left?(flash[:leaderboard_pg])
        @show_more = true
      else
        @show_more = false
      end
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
    end
    
    def more
      flash[:old_pg] = flash[:leaderboard_pg]

      if flash[:leaderboard_pg] == nil || flash[:leaderboard_pg] == 0 || flash[:leaderboard_pg] == 1
        flash[:leaderboard_pg] = 2
      else
        flash[:leaderboard_pg] += 1
      end
      @new_users = User.get_leaderboard(flash[:leaderboard_pg])
      if User.more_leaderboard_left?(flash[:leaderboard_pg])
        @show_more = true
      else
        @show_more = false
      end
      respond_to do |format|
        format.html { redirect_to :action => 'index' }
        format.js 
      end
    end

    def post_to_wall
      @user = User.find(flash[:user_id])
      flash[:user_id] = flash[:user_id]
      flash[:pic_pg] = flash[:pic_pg]
      flash[:post_pg] = flash[:post_pg]
      @author = current_user
      @post = Post.new("user_id"=>@user.id, "created_at"=>Time.now,"author_id"=>@author.id,"message"=>params[:post]['message'])
      
      if @user.friends.include?(@author) || @user == @author
        @post.save
      else
        flash[:notice] = "You can only post on the walls of users who follow you."
      end
      redirect_to @user
    end
    
    def destroy_post
      flash[:user_id] = flash[:user_id]
      flash[:pic_pg] = flash[:pic_pg]
      flash[:post_pg] = flash[:post_pg]
      post = Post.find(params[:id])
      if current_user.id == post.user_id || current_user.id == post.author_id || current_user.is_admin
        post.destroy
      end
      redirect_to User.find(post.user_id)
    end
    

    def new
      @user = User.new
    end

    def create
      @user = User.new(params[:user])
      # Saving without session maintenance to skip
      # auto-login which can't happen here because
      # the User has not yet been activated
      if @user.save_without_session_maintenance
        @user.deliver_activation_instructions!
        flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
        redirect_to root_url
      else
        render :action => :new
      end
      # @user = User.new(params[:user])
      # if @user.save
      #   flash[:notice] = "Account registered!"
      #   redirect_back_or_default :controller => 'users', :action => 'show', :id => @user.id
      # else
      #   render :action => :new
      # end
    end

    def show
      @user = User.find(params[:id])
      @following = @user.friends.limit(12)
      if @user.friends.count > 12
        @following_more = true
      else
        @following_more = false
      end
      @followers = Friendship.find(:all, :conditions => {:friend_id => @user.id}, :limit => 12, :include => :user )
      if Friendship.count(:all, :conditions => {:friend_id => @user.id} ) > 12
        @more_followers = true
      else
        @more_followers = false
      end
      @notifications = Notification.find(:all, :conditions=>['notifications.user_id = ? and (notifications.notification_type = ? or notifications.notification_type = ?)', @user.id, 'follower', 'comment'], :order=>'created_at DESC', :limit=>5)
      flash[:user_id] = params[:id]
      
    # posts  
      if flash[:post_pg] == nil || flash[:post_pg] == 0 || flash[:post_pg] == flash[:old_post_pg] || flash[:ajaxed]
        flash[:post_pg] = 1
      end
      if flash[:post_pg] == 1
        @posts = @user.posts.all(:order => 'created_at DESC', :limit => Post::PG_SIZE)
      else
        flash[:post_pg] = flash[:post_pg]
        @posts = @user.posts.all(:order => 'created_at DESC', :limit => Post::PG_SIZE, :offset => (Post::PG_SIZE*(flash[:post_pg]-1))  )
      end
      flash[:old_post_pg] = flash[:post_pg]
      if @user.posts.count > (Post::PG_SIZE*(flash[:post_pg]))
        @show_more_posts = true
      end

    # pics
      if flash[:pic_pg] == nil || flash[:pic_pg] == 0 || flash[:pic_pg] == flash[:old_pic_pg] || flash[:ajaxed]
        flash[:pic_pg] = 1
      end
      if flash[:pic_pg] == 1
        @pics = @user.pics.all(:order => 'created_at DESC', :limit => Pic::USER_PIC_PG_SIZE)
      else
        flash[:pic_pg] = flash[:pic_pg]
        @pics = @user.pics.all(:order => 'created_at DESC', :limit => Pic::USER_PIC_PG_SIZE, :offset => (Pic::USER_PIC_PG_SIZE*(flash[:pic_pg]-1)))
      end
      flash[:old_pic_pg] = flash[:pic_pg]
      if @user.pics.count > (Pic::USER_PIC_PG_SIZE*(flash[:pic_pg]))
        @show_more_pics = true
      end

      flash[:user_id] = @user.id        #this is used in the more_posts method to find the user that the posts belong to
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
    
    def more_posts
      flash[:old_post_pg] = flash[:post_pg]
      flash[:user_id] = flash[:user_id]
      flash[:pic_pg] = flash[:pic_pg]
      if flash[:post_pg] == nil || flash[:post_pg] == 0 || flash[:post_pg] == 1
        flash[:post_pg] = 2
      else
        flash[:post_pg] += 1
      end
      @user = User.find(flash[:user_id])   # this was set in the show method
      @new_posts = @user.posts.all(:order => 'created_at DESC', :limit => Post::PG_SIZE, :offset => (Post::PG_SIZE*(flash[:post_pg]-1)) )
      if @user.posts.count > (Post::PG_SIZE*(flash[:post_pg]))
        @show_more_posts = true
      end
      flash[:user_id] = @user.id
      respond_to do |format|
        format.html { redirect_to @user }
        format.js 
      end
    end
    
     def more_pics
        flash[:old_pic_pg] = flash[:pic_pg]
        flash[:post_pg] = flash[:post_pg]
        if flash[:pic_pg] == nil || flash[:pic_pg] == 0 || flash[:pic_pg] == 1
          flash[:pic_pg] = 2
        else
          flash[:pic_pg] += 1
        end
        @user = User.find(flash[:user_id])   # this was set in the show method
        @new_pics = @user.pics.all(:order => 'created_at DESC', :limit => Pic::USER_PIC_PG_SIZE, :offset => (Pic::USER_PIC_PG_SIZE*(flash[:pic_pg]-1)) )
        if @user.pics.count > (Pic::USER_PIC_PG_SIZE*(flash[:pic_pg]))
          @show_more_pics = true
        end
        flash[:user_id] = @user.id
        respond_to do |format|
          format.html { redirect_to @user }
          format.js 
        end
    end

    def edit
      @user = current_user
    end

    def update
      @user = current_user
      if @user.update_attributes(params[:user])
        flash[:notice] = "Account updated!"
        redirect_to :controller => 'users', :action => 'show', :id => @user.id
      else
        render :action => :edit
      end
    end
    
end
