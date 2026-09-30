class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, null: false
      t.references :task, foreign_key: true, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
