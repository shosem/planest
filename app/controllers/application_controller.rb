class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # フラッシュのタイプ追加
  add_flash_types :success, :info, :warning, :error

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_group

  private

  def current_group
    return unless user_signed_in?
    # 一度計算したらここでリターンする
    return @current_group if defined?(@current_group)

    # ネストされたパスではgroup_id、groupのパスならidで取る
    id = params[:group_id] || params[:id]
    @current_group = id && current_user.groups.detect { |group| group.id == id.to_i }
  end

  # ログイン後のページ遷移先を自分の個人グループに固定
  def after_sign_in_path_for(resource)
    # 遷移先のパス（個人用グループのidを参照する）
    group_path(resource.personal_group)
  end
end
