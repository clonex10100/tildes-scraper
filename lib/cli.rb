class CommandLineInterface
  BASE_URL = "https://tildes.net/?order=comments&period=7d"
  def run
    PageManager.create_page_from_url(BASE_URL)
    PageManager.create_page_from_url("https://tildes.net/~books")
    binding.pry
  end
end
