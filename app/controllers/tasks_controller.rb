class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def show
  end
  
  def destroy
  end

  private

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end
end
