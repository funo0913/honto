class AddTmpIdToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :tmp_id, :string, null: false, default: ""
  end
end
