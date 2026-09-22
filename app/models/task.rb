class Task < ApplicationRecord
  belongs_to :user
  belongs_to :group

  enum :status, { todo: 0, in_progress: 1, done: 2 }

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }
  validate :user_must_be_group_member

  private

  def user_must_be_group_member
    # nilに対するメソッド呼び出しで落ちるのを防ぐ
    return if user_id.blank? || group_id.blank?

    # グループにそのユーザーが所属してない場合
    return if group.group_members.exists?(user_id: user_id)
    errors.add(:user, "はグループのメンバーではありません")
  end
end
