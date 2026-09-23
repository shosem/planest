class Group < ApplicationRecord
  belongs_to :owner, class_name: "User", inverse_of: :owned_groups
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  # is_personalがtrueで「nilであること」を、falseで「値が入っていること」を検証
  validates :invite_code, presence: true, uniqueness: true, unless: :is_personal?
  validates :invite_code, absence: true, if: :is_personal?

  # after_createだとinvite_codeのバリデーションがうまく作用しないため、バリデーション前にinvite_code作成
  before_validation :generate_invite_code, on: :create, unless: :is_personal?

  # スコープ
  scope :shared, -> { where(is_personal: false) }
  scope :invitable, -> { shared.where.not(invite_code: nil) }

  private

  def generate_invite_code
    # 最終的な保証は DB のユニークインデックス。
    # ここのループは衝突時にエラーを出さないため
    self.invite_code = loop do
      code = SecureRandom.alphanumeric(10)
      break code unless Group.exists?(invite_code: code)
    end
  end
end
