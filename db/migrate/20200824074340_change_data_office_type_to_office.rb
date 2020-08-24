class ChangeDataOfficeTypeToOffice < ActiveRecord::Migration[5.1]
  def change
    change_column :offices, :office_type, :integer
  end
end
