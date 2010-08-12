class PicsController < ApplicationController
  before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy ]
  before_filter :current_user_must_own_pic, :only => [ :edit, :update, :destroy ]
  
  # GET /pics
  # GET /pics.xml
  def index
    if flash[:pg] == nil || flash[:pg] == 0 || flash[:pg] == flash[:old_pg] || flash[:ajaxed]
      flash[:pg] = 1
    end
    if flash[:category] == nil
      flash[:category] = 'new'
    end
    flash[:old_pg] = flash[:pg]
    flash[:category] = flash[:category]
    @pics = Pic.get_pics(flash[:pg], flash[:category])
    if Pic.more_pics_left?(flash[:pg], flash[:category])
      @show_more = true
    else
      @show_more = false
    end
    @tags = Tag.ordered_by_taggings.limit(20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pics }
    end
  end
  
  def more
    flash[:old_pg] = flash[:pg]
    flash[:category] = flash[:category]
    
    if flash[:pg] == nil || flash[:pg] == 0 || flash[:pg] == 1
      flash[:pg] = 2
    else
      flash[:pg] += 1
    end
    @new_pics = Pic.get_pics(flash[:pg], flash[:category])
    if Pic.more_pics_left?(flash[:pg], flash[:category])
      @show_more = true
    else
      @show_more = false
    end
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js 
    end
  end
  
  
  def show_top
    flash[:category] = 'top'
    flash[:pg] = 1
    redirect_to :action => 'index'
  end
  
  def show_hot
    flash[:category] = 'hot'
    flash[:pg] = 1
    redirect_to :action => 'index'
  end
  
  def show_new
    flash[:category] = 'new'
    flash[:pg] = 1
    redirect_to :action => 'index'
  end  
 
  # GET /pics/1
  # GET /pics/1.xml
  def show
    @pic = Pic.find(params[:id]) 
    @next = Pic.get_next(@pic)
    @user = @pic.user
    @taggings = Tagging.find(:all, :include => :tag, :conditions => {:pic_id => @pic.id}, :order => 'created_at')
    flash[:pic_id] = @pic.id
    default_string = "photo, photography, photographer, pic, picture, share, heart, rank, level, reputation, professional, amateur, digital, analog, film, community, crowdsource, social"
    tags_string = ""
    @taggings.each do |tagging| 
      tags_string = "#{tags_string}"+", #{tagging.tag.name}"
    end
    tags_string = tags_string[0..340]
    @keywords_string = "#{default_string}"+"#{tags_string}"
    
    @pic.view_count += 1
    @pic.save
    if flash[:comment_pg] == nil || flash[:comment_pg] == 0 || flash[:comment_pg] == flash[:old_comment_pg] || flash[:ajaxed]
      flash[:comment_pg] = 1
    end
    if flash[:comment_pg] == 1
      @comments = @pic.comments.all(:order => 'created_at DESC', :limit => Comment::PG_SIZE)
    else
      flash[:comment_pg] = flash[:comment_pg]
      @comments = @pic.comments.all(:order => 'created_at DESC', :limit => Comment::PG_SIZE, :offset => (Comment::PG_SIZE*(flash[:comment_pg]-1))  )
    end
    flash[:old_comment_pg] = flash[:comment_pg]
    if @pic.comments.count > (Comment::PG_SIZE*(flash[:comment_pg]))
      @show_more_comments = true
    end
    
    flash[:pic_id] = @pic.id
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pic }
    end
  end

  def random
    @random_pic = Pic.find(:first, :order => "Random()")
    respond_to do |format|
      format.html { redirect_to @random_pic }
    end
  end
  
  def more_comments
    flash[:old_comment_pg] = flash[:comment_pg]
    if flash[:comment_pg] == nil || flash[:comment_pg] == 0 || flash[:comment_pg] == 1
      flash[:comment_pg] = 2
    else
      flash[:comment_pg] += 1
    end
    @pic = Pic.find(flash[:pic_id])
    @new_comments = @pic.comments.all(:order => 'created_at DESC', :limit => 10, :offset => (10*(flash[:comment_pg]-1)) )
    if @pic.comments.count > (10*(flash[:comment_pg]))
      @show_more_comments = true
    end
    flash[:pic_id] = @pic.id
    respond_to do |format|
      format.html { redirect_to @pic }
      format.js 
    end
  end

  # GET /pics/new
  # GET /pics/new.xml
  def new
    @pic = Pic.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pic }
    end
  end

  # GET /pics/1/edit
  def edit
  end

  # POST /pics
  # POST /pics.xml
  def create
    @pic = Pic.new(params[:pic])

    respond_to do |format|
      if @pic.save
        flash[:notice] = 'Pic was successfully created.'
        format.html { redirect_to(@pic) }
        format.xml  { render :xml => @pic, :status => :created, :location => @pic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pics/1
  # PUT /pics/1.xml
  def update
    respond_to do |format|
      if @pic.update_attributes(params[:pic])
        flash[:notice] = 'Pic was successfully updated.'
        format.html { redirect_to(@pic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pics/1
  # DELETE /pics/1.xml
  def destroy
    @pic.destroy

    notifications = Notification.find(:all, :conditions => ['notification_type = ? and object_id = ?', "comment", @pic.id])
    notifications.each do |n|
      n.destroy
    end
    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml  { head :ok }
    end
  end
  
  
private
  
  def current_user_must_own_pic
    @pic = Pic.find params[:id]
    if current_user && (current_user.owns_pic?(@pic) || current_user.is_admin)
      return
    else
      flash[:notice] = 'You must own a pic to edit it.'
      redirect_to :back
    end
  end
  
end
