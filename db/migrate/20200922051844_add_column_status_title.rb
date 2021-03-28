class AddColumnStatusTitle < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_status, :string
    add_column :attendances, :log_edit_status, :string
    add_column :attendances, :before_edit_status, :string
    add_column :attendances, :edit_confirmation, :string
    add_column :attendances, :before_edit_confirmation, :string
  end
end
