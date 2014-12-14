class Post < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :author, :class_name => "User"
  validates :title, :presence => true,  
                    :length => { :minimum => 5 } 
  has_many :comments, :dependent => :destroy 
  friendly_id :title, use: :slugged
  
end
