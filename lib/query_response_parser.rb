class QueryResponseParser
  @@store = {}

  def initialize(path, query)
    @path = path
    @query = query

    parse
  end

  def parse
    query_method = @path.split('?')[0]
    # /set?name=Dave&age=78
    case query_method
    when '/set'
      query_key_values = @query.split('&').map { |e| e.split('=') }
      save_record(query_key_values)
    when '/get'
      key, value = @query.split('=')
      retrieve_record(key, value)
    else
      throw_error
    end

    self
  end

  attr_reader :status_code, :content

  private

  def retrieve_record(key, value)
    throw_error && return unless key == 'key'

    values = value.split('&')
    content_collection = []

    values.each do |e|
      if @@store.key?(e)
        retrieved_value = @@store[e]
        @some_content = "The value of #{e} is: #{retrieved_value}"
      else
        @some_content = "There's no record for #{e}"
      end
      content_collection << @some_content
    end
    @content = content_collection.map { |e| e }.join(', ')
    @status_code = 200
  end

  def save_record(query_key_values)
    content_collection = []
    query_key_values.each do |e|
      key = e[0]
      value = e[1]
      @@store[key] = value
      @some_content = "#{key} has been stored"
      content_collection << @some_content
    end
    @content = content_collection.map { |e| e }.join(', ')
    @status_code = 200
  end

  def throw_error
    @content = 'Request not supported'
    @status_code = 400
  end
end
