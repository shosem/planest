class PagesController < ApplicationController
  def home
  end

  def auth_demo
    render "pages/demo-static/auth_demo"
  end

  def group_detail_demo
    render "groups/_demo/group_detail_demo"
  end
end
