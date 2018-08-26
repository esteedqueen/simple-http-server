class QueryResponseParser
  @@store = {}

  def initialize(path, query)
    @path = path
    @query = query

    parse
  end

  def parse
    query_method = @path.split('?')[0]
    key, value = @query.split('=')

    case query_method
    when '/set'
      save_record(key, value)
    when '/get'
      retrieve_record(key, value)
    else
      throw_error
    end

    self
  end

  attr_reader :status_code, :content

  private

  def save_record(key, value)
    @@store[key] = value
    @content = "#{key} has been stored."
    @status_code = 200
  end

  def retrieve_record(key, value)
    throw_error && return unless key == 'key'

    if @@store.key?(value)
      retrieved_value = @@store[value]
      @content = "The value of #{value} is: #{retrieved_value}"
    else
      @content = "There's no record for #{value}"
    end

    @status_code = 200
  end

  def throw_error
    @content = 'Request not supported'
    @status_code = 400
  end
end
