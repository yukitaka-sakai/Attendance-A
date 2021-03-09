class AddColumnOfficeIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :office_id, :integer
  end
end
