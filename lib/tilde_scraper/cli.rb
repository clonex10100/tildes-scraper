class TildeScraper::CommandLineInterface
  def run
    front_page
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
      when "frontpage"
        front_page
        page_list
      when "groups"
        groups
      when "group"
        group(input.split(" ")[1])
      when "page"
        page
      when "list"
        page_list
      when "next"
        next_page
      when "prev"
        prev_page
      when "view"
        view(input.split(" ")[1])
      when "comments"
        comments(input.split(" ")[1])
      else
        puts "Invalid command"
      end
    end
  end

  def view(index_string)
    index = validate_index(index_string, @page.topics.length)
    return nil if !index
    @page.topics[index].display_content
  end

  def next_page
    if @page.next_link
      @page = TildeScraper::get_page(@page.next_link)
      page_list
    else
      puts "Last page"
    end
  end

  def prev_page
    if @page.next_link
      @page = TildeScraper::get_page(@page.prev_link)
      page_list
    else
      puts "No previous page"
    end
  end

  def groups
    generate_groups
    TildeScraper::Group.display
  end

  def group(index_string)
    generate_groups
    index = validate_index(index_string, TildeScraper::Group.all.length)
    return nil if !index
    @page = TildeScraper::get_page(TildeScraper::Group.all[index].get_url)
    page_list
  end

  def front_page
    @page = TildeScraper::get_page("https://tildes.net")
  end

  def comments(index_string)
    index = validate_index(index_string, @page.topics.length)
    return nil if !index
    topic = @page.topics[index]
    if topic.comments.length == 0
      TildeScraper::get_comments(topic.comment_link)
    end
    TildeScraper::Comment.display_page(topic.comment_link)
  end

  def page_list
    if !@page
      puts "No page selected"
    else
      @page.display
    end
  end

  def help
    puts "To view this list, type: help"
    puts "To view groups: groups"
    puts "To view group page: group [index]"
    puts "To return to front page: frontpage"
    puts "To view topics of current page: list"
    puts "To view next page: next"
    puts "To view prev page: prev"
    puts "To view submission contents: view [index]"
    puts "To view submission comments: comments [index]"
  end

  private
  def validate_index(index_string, max)
    if !index_string || index_string.match(/\D/) || !index_string.to_i.between?(1, max)
      puts "Invalid index"
      return nil
    end
    index_string.to_i - 1
  end

  def generate_groups
    if TildeScraper::Group.all.length == 0
      TildeScraper::Group.create_from_array(TildeScraper::Scraper.scrape_groups("/groups"))
    end
  end
end
