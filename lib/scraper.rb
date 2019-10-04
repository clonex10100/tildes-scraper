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
      topic_text = topic_text.children.reject { |el| el.name == "summary" }
      if topic_text.length > 0
        info[:topic_text] = topic_text.reduce("") { |s, el| s + el.text}
      else
        info[:link] = title.attribute("href").value
      end
      info
    end
    output_array
  end

  def self.scrape_comments(url)
    doc = open_url(url)
    comments = doc.css("#comments")
    array = scrape_children(comments)
    array
  end

  private
  def self.scrape_children(top_comment)
    comments = top_comment.css("> li > article").map do |comment|
      comment_info = comment.css("> div.comment-itself").first
      hash = {
        text: comment_info.css("comment-text").text,
        children: scrape_children(comment.css("> ol.comment-tree-replies"))
      }
      hash
    end
  end
  def self.open_url(url)
    Nokogiri::HTML(open(url))
  end
end
