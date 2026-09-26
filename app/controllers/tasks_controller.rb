class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

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
    # 画面確認用のダミー表示
    @task = Struct.new(:title, :content, :status).new(
      "Hello task",
      "ここにタスクの詳細が表示されます。\n\nHello task",
      "in_progress"
    )

    render :show
  end

  def destroy
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
  
  def set_group
    @group = current_user.groups.find(params[:group_id])
  end
end
