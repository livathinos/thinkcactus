class AddAuthorUrlToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :author_url, :string
  end

  def self.down
    remove_column :comments, :author_url
  end
end
