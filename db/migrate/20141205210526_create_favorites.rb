class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :goodreads_book_id

      t.timestamps

    end
  end
end
