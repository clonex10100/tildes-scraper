class CommandLineInterface
  def run
    @page = PageManager.create_page_from_url("https://tildes.net")
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
      when "groups"
        groups
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
      end
    end
  end

  def view(index_string)
    index = validate_index(index_string)
    return nil if !index
    @page.topics[index].display_content
  end

  def next_page
    if @page.next_link
      @page = PageManager.create_page_from_url(@page.next_link)
      page_list
    else
      puts "Last page"
    end
  end

  def prev_page
    if @page.next_link
      @page = PageManager.create_page_from_url(@page.prev_link)
      page_list
    else
      puts "No previous page"
    end
  end

  def groups
    if Group.all.length == 0
      Group.create_from_array(Scraper.scrape_groups("/groups"))
    end
    Group.display
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
    if !@page
      puts "No page selected"
    else
      @page.display
    end
  end

  def help
    puts "To view this list, type: help"
    puts "To view groups: groups"
    puts "To view topics of current page: list"
    puts "To view next page: next"
    puts "To view prev page: prev"
    puts "To view submission contents: view [index]"
    puts "To view submission comments: comments [index]"
  end

  private
  def validate_index(index_string)
    if !index_string || index_string.match(/\D/) || !index_string.to_i.between?(1, @page.topics.length)
      puts "Invalid index"
      return nil
    end
    index_string.to_i - 1
  end
end
