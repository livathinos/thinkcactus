Factory.define :asset do |f|
  f.sequence(:caption) { |n| "Asset##{n}" }
end

Factory.define :category do |f|
  f.sequence(:name) { |n| "Category##{n}" }
end

Factory.define :comment do |f|
  f.name "John"
  f.email "john+#{f}@example.com"
  f.body "Body of the comment"
  f.association :post
end

Factory.define :page do |f|
  f.sequence(:title) { |n| "Title##{n}" }
  f.body "Content"
end

Factory.define :picture do |f|
  f.sequence(:title) { |n| "Picture##{n}" }
  f.picture_file_name "dog.jpg"
  f.picture_content_type "image/jpeg"
  f.picture_file_size "175938"
  f.picture_updated_at 3.days.ago.to_s(:db)
end

Factory.define :post do |f|
  f.sequence(:title) { |n| "Post##{n}" }
  f.body "Body"
  f.status "published"
end

Factory.define :typus_user do |f|
  f.sequence(:email) { |n| "admin+#{n}@example.com" }
  f.role "admin"
  f.status true
  f.token "1A2B3C4D5E6F"
  f.password "12345678"
  f.preferences Hash.new({ :locale => :en })
end
