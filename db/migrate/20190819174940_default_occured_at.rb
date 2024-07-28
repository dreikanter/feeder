class DefaultOccuredAt < ActiveRecord::Migration[6.0]
  def change
    change_column :errors, :occured_at, :datetime, default: -> { "CURRENT_TIMESTAMP" }
  end
end
