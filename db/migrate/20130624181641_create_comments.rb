class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :article
      t.references :user
      t.timestamps
    end
    add_index :comments, :article_id
    add_index :comments, :user_id
  end
end
