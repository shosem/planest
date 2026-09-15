class CreateGroupMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :group_members do |t|
      # 複合indexで、先頭だけの絞り込みも可能なためuser_idのindexはfalseにしとく
      t.references :user, null: false, foreign_key: true, index: false
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
    add_index :group_members, [ :user_id, :group_id ], unique: true
    # 個人グループは1ユーザーにつき1つだけ作成可能
    add_index :groups, :owner_id, unique: true, where: "is_personal = true"
  end
end
