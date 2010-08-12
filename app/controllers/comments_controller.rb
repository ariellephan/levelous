class CommentsController < ApplicationController
before_filter :require_user, :only => [:create, :destroy]
before_filter :destroy_permissions, :only => :destroy
  
  def create
    @pic = Pic.find(params[:pic]['id'])
    flash[:pic_id] = @pic.id
    @comment = Comment.new("pic_id"=>@pic.id, "created_at"=>Time.now,"user_id"=>current_user.id,"message"=>params[:comment]['message'])
    if @comment.message == nil || @comment.message == ''
      flash[:notice] = "Comments cannot be blank."
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
      return
    elsif @comment.save
      unless @pic.user.id == @comment.user_id
        Notification.create(:user_id=>@pic.user_id, :notification_type=>"comment", :object_id=>@pic.id)
      end
      flash[:notice] = "Comment posted."
      respond_to do |format|
        format.html { redirect_to @pic }
        format.js
      end
    end
  end
  
  def destroy
      if current_user.id == @comment.user_id || current_user.id == @pic.user_id || current_user.is_admin
        if @comment.destroy
          flash[:notice] = "Comment deleted."
        end
      end
      respond_to do |format|
         format.html { redirect_to @pic }
         format.js
      end
  end
  
private
  
  def destroy_permissions
    @comment = Comment.find(params[:id])
    @pic = Pic.find(@comment.pic_id)
    unless (current_user && (current_user.id == @pic.user_id || current_user.id == @comment.user_id || current_user.is_admin))
      flash[:notice] = "You don't have permission to delete that comment."
      redirect_to :back
      return false
    end
  end
  
end