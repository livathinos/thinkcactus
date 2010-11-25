class Comment < ActiveRecord::Base
  belongs_to :post
  validates :body, :presence => true,
            :length => { :minimum => 5 }
  validates :author_name, :presence => true,
            :length => { :minimum => 5}
end
