class AddOfficeNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :office_number, :integer
  end
end
