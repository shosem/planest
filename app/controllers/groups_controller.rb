class GroupsController < ApplicationController
  before_action :authenticate_user!

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    # user.groups.buildの場合、current_user.groupsにbuildしたオブジェクトが反映されてしまう
    @group.owner = current_user

    @group.group_members.build(user: current_user)
    if @group.save
      redirect_to group_path(@group), success: "グループを作成しました"
    else
      render :new, status: :unprocessable_content
    end
  end
  def show; end

  def destroy
    @group = current_user.owned_groups.find(params[:id])

    if @group.is_personal?
      redirect_to group_path(@group), alert: "個人グループは削除できません", status: :see_other
      return
    end

    @group.destroy!
    redirect_to group_path(current_user.personal_group), success: "グループを削除しました", status: :see_other
  end

  private

  def group_params
    params.expect(group: [ :name ])
  end
end
