class TasksController < ApplicationController
  def new
    @task = Task.new #新しいタスクを作成する
  end

  def create
    @task = Task.new(params[:id])

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
end
