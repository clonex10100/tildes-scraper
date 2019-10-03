class CommandLineInterface
  BASE_URL = "https://tildes.net"
  def run
    Scraper.scrape_comments("https://tildes.net/~comp/i0k/please_recommend_me_a_linux_distribution_that_is_super_stable_and_never_make_me_install_again_but")
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
    puts BASE_URL + link
    comment_array = Scraper.scrape_comments(BASE_URL + link)
    Comment.create_from_array(comment_array)
    binding.pry
    Comment.display
    Comment.all.first.display
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
