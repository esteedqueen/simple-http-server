class RequestParser
  Request = Struct.new(:method, :path, :headers)

  def initialize(connection)
    @connection = connection
  end

  def request
    request_line = @connection.read_line
    method, path, _version = request_line.split(' ', 3)
    headers = {}
    loop do
      line = @connection.read_line
      break if line.empty?
      key, value = line.split(/:\s*/, 2)
      headers[key] = value
    end
    Request.new(method, path, headers)
  end
end
