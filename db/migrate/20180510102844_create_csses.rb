class CreateCsses < ActiveRecord::Migration[5.1]
  def change
    create_table :csses do |t|
      t.string :file

      t.timestamps
    end
  end
end
