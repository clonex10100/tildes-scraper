class LinkTopic < Topic
  attr_accessor :link

  def type
    "link"
  end

  def display_content
    puts "Topic Link: #{link}"
  end
end
