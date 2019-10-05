module TildeScraper
  @@page_id = 0
  def self.get_page(url)
      data = TildeScraper::Scraper.scrape_page(url)
      #Set page_id in page data hash
      data[0][:page_id] = @@page_id
      #Create page object
      page = TildeScraper::Page.create(data[0])

      #Set page_id in all topic data hashes
      #Set group in all hashes if applicible
      data[1].each do |topic_hash|
        if page.group
          topic_hash[:group] = page.group
        end
        topic_hash[:page_id] = @@page_id
      end
      @@page_id += 1;
      #Create topic objects
      TildeScraper::Topic.create_from_array(data[1])
      page
  end

  def self.get_page_with_comments(url)
    page = get_page(url)
    #Create comments for each topic
    page.topics.each do |topic|
      get_comments(topic.comment_link)
    end
  end

  def self.get_groups
    TildeScraper::Group.all.clear
    TildeScraper::Group.create_from_array(TildeScraper::Scraper.scrape_groups("/groups"))
  end

  def self.get_comments(url)
      comment_array = TildeScraper::Scraper.scrape_comments(url)
      TildeScraper::Comment.create_from_array(comment_array)
  end
end
