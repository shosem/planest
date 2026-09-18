class GroupsController < ApplicationController
  before_action :authenticate_user!
  def show
    @group = Group.find(params[:id])

    # 自分がホストのグループ以外にアクセスしようとすると個人ページへ戻される（本当は参加中のグループかどうかを判定したい）
    unless @group.owner_id == current_user.id
      # ログインユーザーのpersonalグループのidを取得している（本当は404エラー画面へ行きたい）
      redirect_to group_path(current_user.personal_group)
    end
  end
end
