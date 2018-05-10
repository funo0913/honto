class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :isbn, null: false
      t.string :title, null: false
      t.string :author, null: false
      t.date :publication, null: false
      t.string :publisher, null: false
      t.integer :review_cnt

      t.timestamps
    end
  end
end
