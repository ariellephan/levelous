class WelcomeController < ApplicationController
#before_filter :require_no_user

  def index
    if current_user
      redirect_to pics_url
    end
    
    @user_session = UserSession.new
    @pics = Pic.ordered_by_hearts.limit(Pic::USER_PIC_PG_SIZE)
  end
 
end