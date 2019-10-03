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
    page_buttons = doc.css("a.page-item").each do |button|
      button_name = button.text
      output_array[0]["#{button_name.downcase}_link".to_sym] = button.attribute("href").value
    end

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
      topic_text = topic.css(".topic-text-excerpt")
      if topic_text.length > 0
        if topic_text.length == 1
          info[:topic_text] = topic_text.text
        else
          info[:topic_text] = topic_text[1..-1].text
        end
      else
        info[:link] = title.attribute("href").value
      end
      info
    end
    binding.pry
    output_array
  end

  private
  def self.open_url(url)
    Nokogiri::HTML(open(url))
  end
end
