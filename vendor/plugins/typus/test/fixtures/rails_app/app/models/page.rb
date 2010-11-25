class Page < ActiveRecord::Base

  acts_as_tree

  default_scope where(:status => true)

end
