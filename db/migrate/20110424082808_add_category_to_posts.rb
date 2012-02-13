class AddCategoryToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.string :category
    end
  end

  def self.down
    remove_column :posts, :category
  end
end
