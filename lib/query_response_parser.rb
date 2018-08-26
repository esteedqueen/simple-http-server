require 'pstore'

class QueryResponseParser
  def initialize(path, query)
    @path = path
    @query = query
    @store = PStore.new('dbserver.pstore')

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
    @store.transaction { @store[key] = value }
    @content = "#{key} has been stored."
    @status_code = 200
  end

  def retrieve_record(key, value)
    throw_error && return unless key == 'key'

    retrieved_value = @store.transaction { @store[value] }
    @content = "The value of #{value} is: #{retrieved_value}"
    @status_code = 200
  end

  def throw_error
    @content = 'Request not supported'
    @status_code = 400
  end
end
