require_relative 'query_response_parser'
require_relative 'path_response_parser'

class Response
  def initialize(request, client_conn_socket)
    @client_conn_socket = client_conn_socket
    @request = request
    @path = @request.path
    @query = @request.query
  end

  def prepare
    response = if @query.nil?
                 PathResponseParser.new(@path)
               else
                 QueryResponseParser.new(@path, @query)
               end

    content = response.content
    status_code = response.status_code

    p "#{@request.method} #{@request.path} - #{status_code}"

    parse_response(status_code, content)
  end

  private

  def parse_response(status_code, content)
    status_text = {
      200 => 'OK',
      404 => 'Not Found',
      400 => 'Bad Request'
    }.fetch(status_code)

    @client_conn_socket.send("HTTP/1.1 #{status_code} #{status_text}\r\n", 0)
    @client_conn_socket.send("Content-Length: #{content.length}\r\n", 0)
    @client_conn_socket.send("\r\n", 0)
    @client_conn_socket.send(content, 0)
  end
end
