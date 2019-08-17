class AddTargetToErrors < ActiveRecord::Migration[5.2]
  def change
    add_reference :errors, :target, polymorphic: true
    remove_column :errors, :filtered_backtrace, :string, default: [], null: false, array: true
    rename_column :errors, :error_class_name, :exception
  end
end
