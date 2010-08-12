class NotificationsController < ApplicationController
  before_filter :require_user
  before_filter :destroy_permissions, :only => [:destroy]
  
  
  # GET /notifications
  # GET /notifications.xml
  def index
    @notifications =  Notification.find(:all,:order => 'created_at DESC', :conditions => ['user_id = ?', current_user.id], :limit => 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notifications }
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.xml
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to(notifications_url) }
      format.xml  { head :ok }
    end
  end
  
private
  
  def destroy_permissions
     @notification = Notification.find(params[:id])
     unless current_user.id == @notification.user_id || current_user.is_admin
       flash[:notice] = 'You do not have permission to delete that tag.'
       redirect_to :back
     end
   end
  
end
