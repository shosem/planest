class GroupsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @group = Group.find(params[:id])

    # 自分が参加中のグループ以外にアクセスしようとすると弾かれる
    unless current_user.groups.include?(@group)
      # ログインユーザーのpersonalグループのidを取得している（本当は404エラー画面へ行きたい）
      redirect_to group_path(current_user.personal_group)
    end
  end
end
