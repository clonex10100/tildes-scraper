class Scraper
  def self.scrape_page(url)
    doc = open_url(url)
    topics = doc.css("article.topic")
    topic_hashes = topics.map do |topic|
      title = topic.css("h1.topic-title a")
      metadata = topic.css("div.topic-metadata")
      info = {
        title: title.text,
        comment_link: topic.css("div.topic-info-comments a").attribute("href").value.split(" ").first,
        group: metadata.css("span.topic-group").text,
        word_count: metadata.css("span.topic-content-metadata").text.split(" ")[0],
        age: topic.css("time.time-responsive").attribute("data-abbreviated").value,
        votes: topic.css("div.topic-voting span.topic-voting-votes").text
      }
    end
    topics = Topic.create_from_array(topic_hashes)
    page = Page.create(
      {
        url: url,
        topics: topics,
      }
    )
    binding.pry
  end

  private
  def self.open_url(url)
    Nokogiri::HTML(open(url))
  end
end
