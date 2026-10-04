class CommentsController < ApplicationController
  # createアクション実装者は、turbo_streamで描くパーシャルに、
  # tasks/show.html.erb:55で渡しているようなshow_date（boolean）も渡してください。
  # show_dateはコメント表示欄に日付を表示するかどうか、です。
  # 判定は、「最後のコメントがない場合」or「最後のコメントが当日じゃない場合」です！
  # byしょせ
  # むずかったらきいてー

  def destroy
    @comment = current_user.comments.find(params[:id])
    task_id = @comment.task_id
    @comment.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to task_path(task_id), success: "コメントを削除しました" }
    end
  end
end
