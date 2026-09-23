class TasksController < ApplicationController
  def show
    # 画面確認用のダミー表示
    @task = Struct.new(:title, :content, :status).new(
      "Hello task",
      "ここにタスクの詳細が表示されます。\n\nHello task",
      "in_progress"
    )

    render :show
  end
end
