class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 12 }

  # user.owned_groupsでオーナーのグループを辿れる。
  # dependentでuser削除にグループも削除するかは検討中。
  # inverse_ofは双方向関連付け
  has_many :owned_groups, class_name: "Group", foreign_key: :owner_id, inverse_of: :owner
  has_many :group_members, dependent: :destroy
  has_many :groups, -> { order(:created_at) }, through: :group_members

  after_create :generate_personal_group

  def personal_group
    groups.detect(&:is_personal?)
  end

  def shared_groups
    groups.shared.reorder(group_members: { created_at: :asc })
  end

  private
  def generate_personal_group
    self.groups.create!(name: name, owner: self, is_personal: true)
  end
end
