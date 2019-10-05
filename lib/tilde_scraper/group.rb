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
    all.each do |group|
      group.display
      puts ""
    end
  end
end
