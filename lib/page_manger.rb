class PageManager
  @@index = 0

  def self.create_page_from_url(url)
    data = Scraper.scrape_page(url)
    #Set page_id in page data hash
    data[0][:page_id] = @@index
    #Create page object
    page = Page.create(data[0])

    #Set page_id in all topic data hashes
    #Set group in all hashes if applicible
    data[1].each do |topic_hash|
      if page.group
        topic_hash[:group] = page.group
      end
      topic_hash[:page_id] = @@index
    end
    @@index += 1;
    #Create topic objects
    Topic.create_from_array(data[1])
    page
  end
end
