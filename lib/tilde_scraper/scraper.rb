class TildeScraper::Scraper
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
        comment_count: topic.css("div.topic-info-comments").text.strip,
        comment_link: "https://tildes.net" + topic.css("div.topic-info-comments a").attribute("href").value.split(" ").first,
        group: metadata.css("span.topic-group").text,
        word_count: metadata.css("span.topic-content-metadata").text.split(" ")[0],
        age: topic.css("time.time-responsive").attribute("data-abbreviated").value,
        votes: topic.css("div.topic-voting span.topic-voting-votes").text
      }
      topic_text = topic.css(".topic-text-excerpt")
      topic_text = topic_text.children.reject { |el| el.name == "summary" }
      if topic_text.length > 0
        info[:topic_text] = topic_text.reduce("") { |s, el| s + el.text}.strip
      else
        info[:link] = title.attribute("href").value
      end
      info
    end
    output_array
  end

  def self.scrape_groups(url)
    doc = open_url(url)
    out = doc.css("tr.group-level-0").map do |group|
      {
        name: group.css("a").text,
        description: group.css("p").text,
        subs: group.css("span.group-subscription-count").text.split(" ").first
      }
    end
    out
  end

  def self.scrape_comments(url)
    doc = open_url(url)
    comments = doc.css("#comments")
    array = scrape_children(comments, url)
    array
  end

  private
  def self.scrape_children(top_comment, url, level = 0)
    comments = top_comment.css("> li > article").map do |comment|
      comment_info = comment.css("> div.comment-itself").first
      hash = {
        text: comment_info.css("div.comment-text").text.strip,
        author: comment_info.css("a.link-user").text,
        votes: comment_info.css("div.comment-votes").text.split(" ").first,
        level: level,
        url: url,
        children: scrape_children(comment.css("> ol.comment-tree-replies"), url, level + 1)
      }
      hash
    end
    comments
  end
  def self.open_url(url)
    Nokogiri::HTML(open(url))
  end
end
