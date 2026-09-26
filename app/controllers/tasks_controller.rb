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

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end
end
