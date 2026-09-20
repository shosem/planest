class PagesController < ApplicationController
  before_action :authenticate_user!, only: :home
  def home
  end

  def auth_demo
    render "pages/demo-static/auth_demo"
  end

  def group_detail_demo
    render "groups/_demo/group_detail_demo"
  end

  def group_invite_demo
    render "groups/_demo/join_demo/"
  end

  def join_demo
  end
end
