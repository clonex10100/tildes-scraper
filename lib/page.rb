class Page
  attr_accessor :url, :next_link, :prev_link, :order, :period, :page_id, :group

  extend Memorable::ClassMethods
  include Memorable::InstanceMethods

  @@all = []

  def self.all
    @@all
  end

  def initialize(attributes)
    super(attributes)
    get_query
  end

  def topics
    Topic.find_by_page_id(page_id)
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
