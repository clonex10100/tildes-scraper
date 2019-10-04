class CommandLineInterface
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
        font_page
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
      end
    end
  end

  def view(index_string)
    index = validate_index(index_string, @pagic.topics.length)
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
    generate_groups
    Group.display
  end

  def group(index_string)
    generate_groups
    index = validate_index(index_string, Group.all.length)
    return nil if !index
    @page = PageManager.create_page_from_url(Group.all[index].get_url)
    page_list
  end

  def front_page
    @page = PageManager.create_page_from_url("https://tildes.net")
  end

  def comments(index_string)
    index = validate_index(index_string, @page.topics.length)
    return nil if !index
    link = @page.topics[index].comment_link
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
    if Group.all.length == 0
      Group.create_from_array(Scraper.scrape_groups("/groups"))
    end
  end
end
