class Scraper
  def self.scrape_topics(url)
    doc = open_url(url)    
    topics = doc.css("article.topic")
    topics.map do |topic|
      title = topic.css("h1.topic-title a")
      metadata = topic.css("div.topic-metadata")
      info = {
        title: title.text,
        link: title.attribute("href").value,
        group: metadata.css("span.topic-group").text,
        words: metadata.css("span.topic-content-metadata").text.split(" ")[0],
        age: topic.css("time.time-responsive").attribute("data-abbreviated").value,
        votes: topic.css("div.topic-voting span.topic-voting-votes").text
      }
      binding.pry
      info
    end
  end

  private
  def self.open_url(url)
    Nokogiri::HTML(open(url)) 
  end
end
