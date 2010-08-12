class AdminController < ApplicationController
  before_filter :require_admin
  
  def index
  end
  
  def users
    @users = User.all
  end

end
