class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      @comments = @task.comments
      respond_to do |format| format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_content }
      end
    end
  end

  private

  def comment_params
    params.expect(comment:[ :content ])
  end

  def set_task
    @task = Task.where(group: current_user.groups).find(params[:task_id])
  end
end
