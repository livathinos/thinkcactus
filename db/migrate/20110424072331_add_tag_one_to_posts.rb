class AddTagOneToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.string :tag_one
    end
  end

  def self.down
    remove_column :posts, :tag_one
  end
end
