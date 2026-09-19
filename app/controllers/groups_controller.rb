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
      flash.now[:error] = "グループを作成できませんでした"
      render :new, status: :unprocessable_content
    end
  end
  def show; end

  private
  
  def group_params
    params.expect(group: [:name])
  end
end
