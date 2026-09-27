class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[ new create ]

  def create
  end

  def edit
  end

  def update
  end

  def show
    @task = Task.where(group: current_user.groups).find(params[:id])
  end

  def destroy
    task = current_user.tasks.find(params[:id])
    group_id = task.group_id
    task.destroy!
    redirect_to group_path(group_id), success: "タスクを削除しました"
  end

  private

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end
end
