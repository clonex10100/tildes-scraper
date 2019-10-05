class TildeScraper::TextTopic < TildeScraper::Topic
  attr_accessor :topic_text

  def type
    "text"
  end

  def content
    topic_text
  end

  def display_content
    puts topic_text
  end
end
