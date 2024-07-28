class CreateBlockedIps < ActiveRecord::Migration[5.2]
  def change
    create_table :blocked_ips do |t|
      t.inet :ip, null: false
      t.datetime :created_at, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, default: -> { "CURRENT_TIMESTAMP" }
    end

    add_index :blocked_ips, :ip, unique: true
  end
end
