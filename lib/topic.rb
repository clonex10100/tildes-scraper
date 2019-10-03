class Topic
  attr_accessor :title, :group, :word_count, :age, :votes, :comment_link

  @@all = []

  def initialize(attributes)
    self.add_attributes(attributes)
  end

  def self.create(attributes)
    topic = new(attributes)
    @@all << topic
  end

  def self.create_from_array(array)
    array.each { |attributes| create(attributes) }
  end

  def add_attributes(attributes)
    attributes.each { |key, value| self.send("#{key}=", value) }
  end

  def self.all
    @@all
  end
end
