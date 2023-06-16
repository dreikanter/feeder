class CreateSparklines < ActiveRecord::Migration[6.1]
  def change
    create_table :sparklines do |t|
      t.belongs_to :feed, foreign_key: true, index: true
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
  end
end
