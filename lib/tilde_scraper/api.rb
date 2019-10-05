module TildeScraper
  @@page_id = 0
  #Scrapes a page at url, creates topic objects for each topic, and returns a page object
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

  #Scrapes a page for topics, and scrapes each topic's comments, returns a page object
  def self.get_page_with_comments(url)
    page = get_page(url)
    #Create comments for each topic
    page.topics.each do |topic|
      get_comments(topic.comment_link)
    end
  end

  #Scrapes the group page for first level groups and returns an array of group objects
  def self.get_groups
    TildeScraper::Group.all.clear
    TildeScraper::Group.create_from_array(TildeScraper::Scraper.scrape_groups("https://tildes.net/groups"))
  end

  #Scrapes a topic page and returns an array of comment objects
  def self.get_comments(url)
      comment_array = TildeScraper::Scraper.scrape_comments(url)
      TildeScraper::Comment.create_from_array(comment_array)
  end
end
