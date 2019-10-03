class Scraper
  #Returns an array with two elements.
  #the first a hash containing general page info
  #the secound an array of hashes containing topic info
  def self.scrape_page(url)
    doc = open_url(url)
    output_array = []

    output_array << {
      url: url,
    }

    topics = doc.css("article.topic")
    output_array << topics.map do |topic|
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
    binding.pry
    output_array
  end

  private
  def self.open_url(url)
    Nokogiri::HTML(open(url))
  end
end
