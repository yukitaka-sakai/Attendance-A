class AddApplicationSuperior < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :application_superior, :integer
    add_column :attendances, :application_superior_name, :string
  end
end
