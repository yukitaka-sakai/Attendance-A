class AddUidToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :uid, :integer
    add_column :users, :employee_number, :integer
  end
end
