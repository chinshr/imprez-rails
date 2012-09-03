class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.string :name
      t.text :body
      t.boolean :template, :default => false, :null => false

      t.timestamps
    end
    add_index :presentations, :template
  end
end
