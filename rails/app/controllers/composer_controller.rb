class ComposerController < ApplicationController
	before_action :authenticate_user!
  def task
 	 # DESIGN PROMPT
  end

  def index
  	render :layout => "singe_page_app"
  end

  def diary
  end

  def library_selector
  	@library = Actuator.all
  	render :layout => "singe_page_app"
  end
end
