class PagesController < ApplicationController
  before_action :authenticate_user!, only: :home
  def home
    redirect_to group_path(current_user.personal_group)
  end
end
