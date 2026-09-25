class TasksController < ApplicationController
  def new
  end

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
end
