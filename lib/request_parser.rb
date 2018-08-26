class RequestParser
  Request = Struct.new(:method, :path, :query, :headers)

  def initialize(connection)
    @connection = connection
  end

  def request
    request_line = @connection.read_line
    method, full_path, _version = request_line.split(' ', 3)
    query = full_path.split('?')[1]
    headers = {}
    loop do
      line = @connection.read_line
      break if line.empty?
      key, value = line.split(/:\s*/, 2)
      headers[key] = value
    end
    Request.new(method, full_path, query, headers)
  end
end
