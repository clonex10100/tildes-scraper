class CommandLineInterface
  BASE_URL = "https://tildes.net/~comp"
  def run
    @page = PageManager.create_page_from_url(BASE_URL)
    @topics = @page.topics
    help
    input = nil
    until input == "exit"
      print "Please Enter A Command: "
      input = gets.strip.downcase
      case input.split(" ").first
      when "help"
        help
      when "exit"
        puts "Goodbye"
      when "list"
        page_list
      when "view"
        view(input.split[1])
      end
    end
  end

  def view(index_string)
    if !index_string || index_string.match(/\D/) || !index_string.to_i.between?(1, @topics.length)
      puts "Invalid index"
      return nil
    end
    index = index_string.to_i - 1
    @topics[index].display_content
  end

  def page_list
    @page.display
  end

  def help
    puts "To view this list, type: help"
    puts "To view submission contents, type: view [index]"
  end
end
