class Topic
  attr_accessor :title, :group, :word_count, :age, :votes, :comment_link, :comments, :page_id

  extend Memorable::ClassMethods
  include Memorable::InstanceMethods

  @@all = []

  def self.find_by_page_id(id)
    all.select { |topic| topic.page_id == id } 
  end

  def self.all
    @@all
  end

  def self.create_from_array(array)
    array.each do |attributes|
      if attributes.keys.include?(:topic_text)
        TextTopic.create(attributes)
      elsif attributes.keys.include?(:link)
        LinkTopic.create(attributes)
      else
        binding.pry
        raise TopicError
      end
    end
  end

  def display 
    puts "#{title} Votes:#{votes}"
    puts "#{group} WC:#{word_count} #{age} #{comments}"
  end

  class TopicError < StandardError
    def message
      "Topic is neither text topic nor link topic"
    end
  end
end
