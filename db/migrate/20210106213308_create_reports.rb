class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :application_onemonth_superior_name
      t.string :approval_month_status
      t.date :report_month
      t.string :report_confirmation
      
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
