class PostsController < ApplicationController
  before_filter :require_user, :only => [:create, :destroy]
  before_filter :destroy_permissions, :only => :destroy

    def create
      @user = User.find(params[:user]['id'])
      flash[:user_id] = @user.id
      flash[:pic_pg] = flash[:pic_pg]
      flash[:post_pg] = flash[:post_pg]
      @post = Post.new("user_id"=>@user.id, "created_at"=>Time.now,"author_id"=>current_user.id,"message"=>params[:post]['message'])
      notify = false
      if @post.message == nil || @post.message == ''
        flash[:notice] = "Posts cannot be blank."
        respond_to do |format|
          format.html { redirect_to :back }
          format.js
        end
        return
      elsif @post.save
        notify = true
        flash[:notice] = "Post added."
        respond_to do |format|
          format.html { redirect_to @user }
          format.js
        end
      end
      if notify
        unless @post.author_id == @user.id
          Notification.create(:user_id => @user.id, :notification_type => 'post', :object_id => @post.author_id)
        end
      end
    end

    def destroy
      flash[:user_id] = flash[:user_id]
      flash[:pic_pg] = flash[:pic_pg]
      flash[:post_pg] = flash[:post_pg]
        if current_user.id == @post.user_id || current_user.id == @post.author_id || current_user.is_admin
          if @post.destroy
            flash[:notice] = "Post deleted."
          end
        end
        respond_to do |format|
           format.html { redirect_to @user}
           format.js
        end
    end

  private

    def destroy_permissions
      @post = Post.find(params[:id])
      unless (current_user && (current_user.id == @post.user_id || current_user.id == @post.author_id || current_user.is_admin))
        flash[:notice] = "You don't have permission to delete that post."
        redirect_to :back
        return false
      end
    end
end