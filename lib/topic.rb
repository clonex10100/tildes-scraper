class Topic
  attr_accessor :title, :group, :word_count, :age, :votes, :comment_link, :page_id

  extend Memorable::ClassMethods
  include Memorable::InstanceMethods

  @@all = []

  def self.find_by_page_id(id)
    all.select { |topic| topic.page_id == id } 
  end

  def self.all
    @@all
  end
end
