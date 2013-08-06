class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :author
      t.string :content
      t.string :teaser
      t.integer :user_id
      t.timestamps
    end
  end
end
