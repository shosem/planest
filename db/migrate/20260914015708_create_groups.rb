class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.string :invite_code
      t.boolean :is_personal, null: false, default: false

      t.timestamps
    end

    # nullじゃないinvite_codeのインデックス
    add_index :groups, :invite_code, unique: true, where: "invite_code IS NOT NULL"

    # 「個人グループならNULL、通常グループなら値あり」をDB側で保証
    add_check_constraint :groups, <<~SQL.squish, name: "groups_invite_code_presence"
      (is_personal = true  AND invite_code IS NULL) OR
      (is_personal = false AND invite_code IS NOT NULL)
    SQL
  end
end
