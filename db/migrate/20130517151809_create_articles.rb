class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :tags
      t.string :headline
      t.string :content
      t.string :takeaway
      t.integer :user_id
      t.timestamps
    end
  end
end
