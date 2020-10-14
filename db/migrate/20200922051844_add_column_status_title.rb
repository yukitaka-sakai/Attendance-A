class AddColumnStatusTitle < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_status, :string
    add_column :attendances, :status, :string
    add_column :attendances, :edit_confirmation, :string
  end
end
