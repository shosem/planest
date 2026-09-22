class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true, null: false
      t.references :group, foreign_key: true, null: false
      t.string :title, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
