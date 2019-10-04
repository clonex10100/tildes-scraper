class CommandLineInterface
  def run
    @page = PageManager.create_page_from_url("https://tildes.net/?order=comments")
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
        view(input.split(" ")[1])
      when "comments"
        comments(input.split(" ")[1])
      end
    end
  end

  def view(index_string)
    index = validate_index(index_string)
    return nil if !index
    @topics[index].display_content
  end

  def comments(index_string)
    index = validate_index(index_string)
    return nil if !index
    link = @topics[index].comment_link
    comment_array = Scraper.scrape_comments(link)
    Comment.create_from_array(comment_array)
    binding.pry
    Comment.display_page(link)
  end

  def page_list
    @page.display
  end

  def help
    puts "To view this list, type: help"
    puts "To view submission contents, type: view [index]"
  end

  private
  def validate_index(index_string)
    if !index_string || index_string.match(/\D/) || !index_string.to_i.between?(1, @topics.length)
      puts "Invalid index"
      return nil
    end
    index_string.to_i - 1
  end
end
