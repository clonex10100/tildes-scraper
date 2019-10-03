class Scraper
  def self.scrape_topics(url)
    doc = open_url(url)    
  end

  private
  def self.open_url(url)
    Nokogiri::HTML(open(url)) 
  end
end
