class TildeScraper::LinkTopic < TildeScraper::Topic
  attr_accessor :link

  def type
    "link"
  end

  def content
    link
  end

  def display_content
    puts "Topic Link: #{link}"
  end
end
