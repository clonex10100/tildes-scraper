class CommandLineInterface
  BASE_URL = "https://tildes.net"
  def run
    Scraper.scrape_topics(BASE_URL)
  end
end
