class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[new create]

  def new
    @task = Task.new # 新しいタスクを作成する
  end

  def create
    @task = @group.tasks.build(task_params)
    @task.user_id = current_user.id

    if @task.save
      redirect_to group_path(@group), success: "タスクを作成しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to task_path(@task), success: "タスクを更新しました"
    else
      render :edit, status: :unprocessable_content
    end
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

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end
end
