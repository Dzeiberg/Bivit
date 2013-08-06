class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :text
      t.string :html
      t.references :room
      t.references :author

      t.timestamps
    end
  end
end
