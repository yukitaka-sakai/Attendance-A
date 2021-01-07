class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :application_onemonth_superior_name
      t.boolean :approval_month_status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
