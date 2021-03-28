class AddChangeAttendanceColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_started_at, :datetime
    add_column :attendances, :edit_finished_at, :datetime
    add_column :attendances, :edit_next_day, :string
    add_column :attendances, :before_started_at, :datetime
    add_column :attendances, :before_finished_at, :datetime
    add_column :attendances, :before_next_day, :string
    add_column :attendances, :edit_approval_date, :date
    add_column :attendances, :edit_note, :string
    add_column :attendances, :before_edit_note, :string
    add_column :attendances, :log_started_at, :datetime
    add_column :attendances, :log_finished_at, :datetime
  end
end
