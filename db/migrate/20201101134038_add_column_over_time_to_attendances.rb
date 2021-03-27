class AddColumnOverTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_finished_at, :datetime
    add_column :attendances, :overtime_next_day, :string
    add_column :attendances, :overtime_note, :string
    add_column :attendances, :overtime_status, :string
    add_column :attendances, :overtime_confirmation, :string
    add_column :attendances, :overtime_application_superior_name, :string
    add_column :attendances, :log_overtime_finished_at, :datetime
    add_column :attendances, :log_overtime_next_day, :string
    add_column :attendances, :log_overtime_note, :string
    add_column :attendances, :log_overtime_status, :string
    add_column :attendances, :log_overtime_confirmation, :string
    add_column :attendances, :log_application_superior_name, :string
    add_column :attendances, :overtimes, :string
  end
end
