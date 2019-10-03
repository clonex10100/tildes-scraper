class PageManager
  @@index = 0

  def self.create_page_from_url(url)
    data = Scraper.scrape_page(url)
    #Set page_id in page data hash
    data[0][:page_id] = @@index
    #Set page_id in all topic data hashes
    data[1].each do |topic_hash|
      topic_hash[:page_id] = @@index
    end
    @@index += 1;
    #Create topic objects
    Topic.create_from_array(data[1])
    #Create page object
    page = Page.create(data[0])
    page
  end
end
