class AddColumnToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :application_onemonth_superior_name, :string
    add_column :attendances, :one_month_status, :string
  end
end
