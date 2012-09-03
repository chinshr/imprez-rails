class AddCodeToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :code, :string
    add_index :presentations, :code, :unique => true
  end
end
