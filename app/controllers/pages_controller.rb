class PagesController < ApplicationController
  def home
  end

  def auth_demo
    render "pages/demo-static/auth_demo"
  end
end
