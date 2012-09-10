class PagesController < ApplicationController
  
  def index
    render :layout => "welcome"
  end

end
