class SearchController < ApplicationController
  
  def pics
    if flash[:search_pg] == nil || flash[:search_pg] == 0 || flash[:search_pg] == flash[:old_search_pg] || flash[:ajaxed]
      flash[:search_pg] = 1
    end
    flash[:old_search_pg] = flash[:search_pg]    
    flash[:search] = params[:search]
    @pics = Pic.search(flash[:search], flash[:search_pg])
    @search = flash[:search]
    if Pic.more_search_pics_left?(flash[:search], flash[:search_pg])
      @show_more = true
    else
      @show_more = false
    end
  end
  
  def more
     flash[:old_search_pg] = flash[:search_pg]

     if flash[:search_pg] == nil || flash[:search_pg] == 0 || flash[:search_pg] == 1
       flash[:search_pg] = 2
     else
       flash[:search_pg] += 1
     end
     @new_pics = Pic.search(flash[:search], flash[:search_pg])
     if Pic.more_search_pics_left?(flash[:search], flash[:search_pg])
       @show_more = true
     else
       @show_more = false
     end
     respond_to do |format|
       format.html { redirect_to :action => 'pics' }
       format.js 
     end
   end
  
end
