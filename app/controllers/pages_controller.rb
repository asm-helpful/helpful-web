class PagesController < ApplicationController

  def home
  end

  def show
    render :action => params[:page], :layout => (params[:layout] || 'application')
  end

  def styleguide
    render :action => params[:page], :layout => (params[:layout] || 'application')
  end

end
