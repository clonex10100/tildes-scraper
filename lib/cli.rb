class CommandLineInterface
  BASE_URL = "https://tildes.net"
  def run
    Scraper.scrape_page(BASE_URL)
  end
end
