class CreateOffices < ActiveRecord::Migration[5.1]
  def change
    create_table :offices do |t|
      t.string :office_name
      t.integer :office_number

      t.timestamps
    end
  end
end
