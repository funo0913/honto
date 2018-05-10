class CreateWarningReports < ActiveRecord::Migration[5.1]
  def change
    create_table :warning_reports do |t|
      t.references :review, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :dealt, default: false

      t.timestamps
    end
  end
end
