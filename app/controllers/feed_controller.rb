class FeedController < ApplicationController
  before_filter :require_user, :only => [:index, :more_feed, :more_feed_left?]
  
  def index
    if flash[:feed_pg] == nil || flash[:feed_pg] == 0 || flash[:ajaxed]
      flash[:feed_pg] = 1
    end
    @pics = Pic.find(:all, :joins=>" INNER JOIN friendships ON pics.user_id = friendships.friend_id WHERE friendships.user_id = #{current_user.id}", :order => 'created_at DESC', :offset => 20*(flash[:feed_pg]-1), :limit =>20)
    @show_more = more_feed_left?
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pics }
    end
  end
  
  def more_feed
    if flash[:feed_pg] == nil || flash[:feed_pg] == 0
      flash[:feed_pg] = 1
    end
    flash[:feed_pg] += 1
    @new_pics = Pic.find(:all, :joins=>" INNER JOIN friendships ON pics.user_id = friendships.friend_id WHERE friendships.user_id = #{current_user.id}", :order => 'created_at DESC', :offset => 20*(flash[:feed_pg]-1), :limit =>20)
    @show_more = more_feed_left?
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js 
    end
  end

  def more_feed_left?
    if flash[:feed_pg] == nil || flash[:feed_pg] == 0 
      flash[:feed_pg] = 1
    end
    return Pic.find(:all, :joins=>" INNER JOIN friendships ON pics.user_id = friendships.friend_id WHERE friendships.user_id = #{current_user.id}").length > 20*flash[:feed_pg]
  end
  
end
