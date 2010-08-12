class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      user = User.find_by_login(params[:user_session][:login])
      if user.last_login == nil || user.consecutive_login_days == nil
        user.consecutive_login_days = 1
      else 
        if user.last_login == (Date.today - 1.day)
          user.consecutive_login_days += 1
        elsif user.last_login != Date.today 
          user.consecutive_login_days = 1
        end
        user.hearts_left += 9 + user.level
      end  
      user.last_login = Date.today
      user.save
      redirect_to root_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    redirect_to root_url
  end
end