class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :content, presence: true, length: { maximum: 65_535 }
  validate :user_must_be_group_member

  private

  def user_must_be_group_member
    # id ではなく関連そのものを見る。行が無ければここで抜ける
    return if user_id.blank? || task.blank?
    group = task.group
    return if group.blank?   # タスクはあるがグループが消えている場合
    return if group.group_members.exists?(user_id: user_id)
    errors.add(:user, "はグループのメンバーではありません")
  end
end
