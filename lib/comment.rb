class Comment
  extend Memorable::ClassMethods
  include Memorable::InstanceMethods

  attr_accessor :children, :parent, :text, :author, :votes, :age, :url

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

  def display(indent = 0)
    puts "\t" * indent + self.text
  end

  def self.display_page(url)
    display(find_by_url(url))
  end

  def self.display(array = all)
    array.each do |comment|
      comment.display
      display(comment.children)
    end
  end

  def self.all
    @@all
  end
end
