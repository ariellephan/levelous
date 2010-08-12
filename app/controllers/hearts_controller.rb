class HeartsController < ApplicationController
  before_filter :require_user, :only => [:create]
  before_filter :hearting_permissions, :only => [:create]
  
  def create
    @pic = Pic.find(params[:id])
    case current_user.heart_pic(@pic)
      when 1 then flash[:notice] = "Error hearting pic."
      when 2 then flash[:notice] = "You have no hearts left to give."
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

private 
  
  def hearting_permissions
     @pic = Pic.find(params[:id])
     if current_user && ( !current_user.owns_pic?(@pic) || current_user.is_admin )
       return
     else
       flash[:notice] = 'You may not heart your own pics.'
        respond_to do |format|
           format.html { redirect_to @pic }
           format.js { render :template => "/hearts/hearting_permissions.rjs" }
         end
     end
   end
   
end