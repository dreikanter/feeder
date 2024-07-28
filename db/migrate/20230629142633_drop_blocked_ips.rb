class DropBlockedIps < ActiveRecord::Migration[6.1]
  def self.up
    drop_table :blocked_ips
  end

  def self.down
    create_table :blocked_ips do |t|
      t.inet :ip, null: false
      t.datetime :created_at, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
