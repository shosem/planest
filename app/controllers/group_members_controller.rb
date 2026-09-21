class GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  def new
    if current_user.groups.include?(@group)
      redirect_to group_path(@group), info: "すでに参加しています"
    end
  end

  def create
    @group.group_members.create!(user: current_user)
    redirect_to group_path(@group), success: "#{@group.name}に参加しました"
  end

  private
  def set_group
    @group = Group.find_by(invite_code: params[:invite_code])
  end
end
