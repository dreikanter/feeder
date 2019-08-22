class AddValidationErrorsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :validation_errors, :string, array: true, default: [], null: false
  end
end
