class GroupMembersController < ApplicationController
  def new
    @group = Group.find_by(invite_code: params[:invite_code])
    if current_user.groups.include?(@group)
      redirect_to group_path(@group), info: "すでに参加しています"
    end
  end

  def create
    @group = Group.find_by(invite_code: params[:invite_code])
    @group.group_members.create!(user: current_user)
    redirect_to group_path(@group), success: "#{@group.name}に参加しました"
  end
end
