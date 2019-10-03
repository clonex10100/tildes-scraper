class Page
  attr_accessor :topics, :url, :next_link, :prev_link, :order, :period

  extend Memorable::ClassMethods
  include Memorable::InstanceMethods

  def initialize(attributes)
    super(attributes)
    get_query
  end

  private
  def get_query
    url_array = url.split("?")
    query_hash = {order: "Activity", period: "All Time"}
    if url_array.length == 2
      query_hash = url_array[1].split("&").reduce(query_hash) do |hash, var|
        var = var.split("=")
        hash[var[0].to_sym] = var[1]
        hash
      end
    end
    add_attributes(query_hash)
  end
end
