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
    query_hash = {}
    if url_array.length > 1
      query = url_array[1]
      query_hash = query.split("&").reduce(query_hash) do |hash, var|
        var = var.split("=")
        hash[var[0].to_sym] = var[1]
      end
    end
    if !query_hash.keys.include?(:order)
      query_hash[:order] = "Activity"
    end
    if !query_hash.keys.include?(:period)
      query_hash[:period] = "All Time"
    end
    binding.pry
    add_attributes(query_hash)
  end
end
