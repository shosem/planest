class TasksController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @task = Task.new #新しいタスクを作成する
  end

  def create
    @group = Group.find(params[:group_id])
    @task = @group.tasks.build(task_params)
    @task.user_id = current_user.id

    if @task.save
      redirect_to group_path(@group), success: "タスクを作成しました"
    else
      render :new, status: :unprocessable_content
    end
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

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end
