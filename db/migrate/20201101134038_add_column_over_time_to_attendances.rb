class AddColumnOverTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_finished_at, :datetime
    add_column :attendances, :overtime_next_day, :string
    add_column :attendances, :overtime_note, :string
    add_column :attendances, :overtime_status, :string
    add_column :attendances, :overtime_confirmation, :string
  end
end
