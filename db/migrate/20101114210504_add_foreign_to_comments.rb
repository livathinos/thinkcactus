class AddForeignToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :post_id, :integer
  end

  def self.down
  end
end
