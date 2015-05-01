class StudyController < ApplicationController
  # before_action :authenticate_user!
  def index
  end
  def info
  end

  def task 
  	@tasks = current_user.tasks
  end

  def save_info
  	redirect_to :controller => "study", :action => "task"
  end
end
