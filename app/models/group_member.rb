class GroupMember < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # DB前にモデルでユニークをかける
  validates :user_id, uniqueness: { scope: :group_id }
end
