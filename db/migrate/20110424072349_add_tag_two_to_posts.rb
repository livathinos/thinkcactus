class AddTagTwoToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.string :tag_two
    end
  end

  def self.down
    remove_column :posts, :tag_two
  end
end
