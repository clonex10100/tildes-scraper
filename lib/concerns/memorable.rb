module Memorable
  module ClassMethods
    @@all = []

    def create(attributes)
      topic = new(attributes)
      @@all << topic
      topic
    end

    def create_from_array(array)
      array.map { |attributes| create(attributes) }
    end

    def all
      @@all
    end
  end

  module InstanceMethods
    def initialize(attributes)
      self.add_attributes(attributes)
    end

    def add_attributes(attributes)
      attributes.each { |key, value| self.send("#{key}=", value) }
    end
  end
end
