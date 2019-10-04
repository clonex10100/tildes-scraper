class Comment
  extend Memorable::ClassMethods
  include Memorable::InstanceMethods

  attr_accessor :children, :text, :author, :votes, :age, :url, :level

  @@all = []

  def initialize(attributes)
    add_attributes(attributes.reject { |key, val| key == :children })
  end

  def self.create_from_array(array)
    array.map do |comment_hash|
      comment = create(comment_hash.reject { |key, val| key == :children })
      comment.children = self.create_from_array(comment_hash[:children])
      comment
    end
  end

  def self.find_by_url(url)
    all.select { |comment| comment.url == url }
  end

  def self.find_top_by_url(url)
    all.select { |comment| comment.url == url && comment.level == 0}
  end

  def display(indent = 0)
    indent(indent)
    puts self.author
    display_text(indent)
    indent(indent)
    puts "Votes: " + self.votes if self.votes
    puts "-" * 10
  end

  def display_text(indent = 0)
    self.text.split("\n").each do |line|
      indent(indent)
      puts line
    end
  end

  def self.display_page(url)
    display(find_top_by_url(url))
  end

  def self.display(array, indent = 0)
    #binding.pry
    array.each do |comment|
      comment.display(indent)
      display(comment.children, indent + 1)
    end
  end

  def self.all_top
    @@all.select { |comment| comment.level == 0 }
  end

  def self.all
    @@all
  end

  private
  def indent(n)
    print "\t" * n
  end
end
