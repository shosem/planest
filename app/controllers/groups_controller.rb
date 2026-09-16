class GroupsController < ApplicationController
  before_action :authenticate_user!
  def show
    @group_detail = Group.all
  end
end
