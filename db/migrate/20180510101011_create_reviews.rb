class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.references :status, foreign_key: true
      t.string :title
      t.text :innocent_review
      t.text :review
      t.boolean :private, default: false
      t.boolean :warning, default: false

      t.timestamps
    end
  end
end
