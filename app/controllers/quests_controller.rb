class QuestsController < ApplicationController
  before_filter :require_admin, :except => [:complete, :index, :show]
  before_filter :require_user, :only => [:complete]
  
  def complete
    @quest = Quest.find(params[:id])
    if current_user 
        if @quest.completed?(current_user)
          @quest.complete(current_user)
          flash[:notice] = "Congrats! You completed '#{@quest.title}'."
          redirect_to :quests
        else
          flash[:notice] = 'You have not completed this quest.'
          redirect_to :back
        end
    end
  end
  
  # GET /quests
  # GET /quests.xml
  def index
    if current_user && current_user.is_admin  
      @quests = Quest.find(:all, :order =>'title')
    elsif current_user
      @quests = Array.new
      list = Quest.all(:conditions => { :level_required => (1..current_user.level) } )
      list.each do |q|
        if CompletedQuest.find(:first, :conditions => {:user_id => current_user.id, :quest_id => q.id}) == nil
          @quests<<q
        end
      end
    else
      @quests = Quest.all(:conditions => { :level_required => 1 } )
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quests }
    end
  end

  # GET /quests/1
  # GET /quests/1.xml
  def show
    @quest = Quest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quest }
    end
  end

  # GET /quests/new
  # GET /quests/new.xml
  def new
    @quest = Quest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quest }
    end
  end

  # GET /quests/1/edit
  def edit
    @quest = Quest.find(params[:id])
  end

  # POST /quests
  # POST /quests.xml
  def create
    @quest = Quest.new(params[:quest])

    respond_to do |format|
      if @quest.save
        flash[:notice] = 'Quest was successfully created.'
        format.html { redirect_to(@quest) }
        format.xml  { render :xml => @quest, :status => :created, :location => @quest }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quest.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quests/1
  # PUT /quests/1.xml
  def update
    @quest = Quest.find(params[:id])

    respond_to do |format|
      if @quest.update_attributes(params[:quest])
        flash[:notice] = 'Quest was successfully updated.'
        format.html { redirect_to(@quest) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quest.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quests/1
  # DELETE /quests/1.xml
  def destroy
    @quest = Quest.find(params[:id])
    @quest.destroy

    respond_to do |format|
      format.html { redirect_to(quests_url) }
      format.xml  { head :ok }
    end
  end
end
