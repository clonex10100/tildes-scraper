module Memorable
  module ClassMethods
    def create(attributes)
      topic = new(attributes)
      self.all << topic
      topic
    end

    def create_from_array(array)
      array.map do |hash|
        create(hash) 
      end
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
