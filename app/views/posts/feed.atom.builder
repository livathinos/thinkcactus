atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated
  feed.description @description
  
  @posts.each do |item|
    next if item.updated_at.blank?

    feed.entry( item ) do |entry|
      entry.url posts_url(item)
      entry.title item.title
      entry.content item.body, :type => 'html'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author "Spyros Livathinos"
    end
  end
end