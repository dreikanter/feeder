class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end

    add_index :permissions, [:user_id, :name], unique: true
  end
end
