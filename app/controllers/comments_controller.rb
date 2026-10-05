class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: :create

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      last = @task.comments.where.not(id: @comment.id).order(:created_at).last
      @show_date = last.nil? || last.created_at.to_date != @comment.created_at.to_date
      @comments = @task.comments
      respond_to do |format| format.turbo_stream
      end
    else
      respond_to do |format| format.turbo_stream { render :create, status: :unprocessable_content }
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @task = @comment.task
    task_id = @comment.task_id
    @comment.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to task_path(task_id), success: "コメントを削除しました" }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_task
    @task = Task.where(group: current_user.groups).find(params[:task_id])
  end
end
