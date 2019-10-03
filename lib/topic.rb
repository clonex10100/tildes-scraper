class Topic
  attr_accessor :title, :group, :word_count, :age, :votes, :comment_link

  extend Memorable::ClassMethods
  include Memorable::InstanceMethods
end
