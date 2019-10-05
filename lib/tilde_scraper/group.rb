class TildeScraper::Group
  extend TildeScraper::Memorable::ClassMethods
  include TildeScraper::Memorable::InstanceMethods

  attr_accessor :name, :description, :subs

  @@all = []

  def self.all
    @@all
  end

  def display
    puts name
    puts description + "    " + subs
  end

  def get_url
    "https://tildes.net/#{name}"
  end

  def self.display
    all.each.with_index(1) do |group, index|
      puts index
      group.display
      puts ""
    end
  end
end
