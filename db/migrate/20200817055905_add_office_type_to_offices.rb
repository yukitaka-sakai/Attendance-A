class AddOfficeTypeToOffices < ActiveRecord::Migration[5.1]
  def change
    add_column :offices, :office_type, :string
  end
end
