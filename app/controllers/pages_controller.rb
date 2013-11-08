class PagesController < ApplicationController

  def home
  end
  
  def widget
    render layout: false
  end

end
