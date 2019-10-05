class TildeScraper::Page
  attr_accessor :url, :next_link, :prev_link, :order, :period, :page_id, :group

  extend TildeScraper::Memorable::ClassMethods
  include TildeScraper::Memorable::InstanceMethods

  @@all = []

  def self.all
    @@all
  end

  def initialize(attributes)
    super(attributes)
    get_query
  end

  def topics
    TildeScraper::Topic.find_by_page_id(page_id)
  end

  def display
    topics.each.with_index(1) do |topic, index|
      puts "#{index}. #{topic.type}post"
      topic.display
      puts ""
    end
  end

  private
  def get_query
    url_array = url.split("?")
    query_hash = {order: "Activity", period: "All Time"}
    group = url.scan(/~\w*/)
    query_hash[:group] = group.length == 1 ? group.first : nil
    if url_array.length == 2
      query_hash = url_array[1].split("&").reduce(query_hash) do |hash, var|
        var = var.split("=")
        hash[var[0].to_sym] = var[1] unless var[0] == "before" || var[0] == "after"
        hash
      end
    end
    add_attributes(query_hash)
  end
end
