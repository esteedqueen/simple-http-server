require 'pstore'

class Response
  def initialize(conn_sock, request)
    @conn_sock = conn_sock
    @request = request
    @path = @request.path
    @query = @request.query
    @store = PStore.new('dbserver.pstore')

    response(@conn_sock)
  end

  private

  def parse_response(client_conn_socket, status_code, content)
    status_text = {
      200 => 'OK',
      404 => 'Not Found'
    }.fetch(status_code)

    client_conn_socket.send("HTTP/1.1 #{status_code} #{status_text}\r\n", 0)
    client_conn_socket.send("Content-Length: #{content.length}\r\n", 0)
    client_conn_socket.send("\r\n", 0)
    client_conn_socket.send(content, 0)
  end

  def response(client_conn_socket)
    if !@query.nil?
      handle_query_response
    else
      handle_path_response
    end

    p "#{@request.method} #{@request.path} - #{@status_code}"

    parse_response(client_conn_socket, @status_code, @content)
  end

  def root_path?
    @path.nil?
  end

  def handle_homepage_response
    @content = File.binread('index.html')
    @status_code = 200
  end

  def handle_file_response
    @content = if File.executable?(file_path)
                 `#{file_path}`
               else
                 File.binread(file_path)
               end
    @status_code = 200
  end

  def handle_404_response
    @content = 'File not found'
    @status_code = 404
  end

  def file_path
    (Dir.getwd + @path).gsub!(/\.+/, '.')
  end

  def handle_path_response
    if root_path?
      handle_homepage_response
    elsif File.exist?(file_path)
      handle_file_response
    else
      handle_404_response
    end
  end

  def handle_query_response
    query_method = @path.split('?')[0]
    key, value = @query.split('=')

    case query_method
    when '/set'
      save_record(key, value)
    when '/get'
      retrieve_record(value)
    end
  end

  def save_record(key, value)
    @store.transaction { @store[key] = value }
    @content = 'Saved'
    @status_code = 200
  end

  def retrieve_record(value)
    retrieved_value = @store.transaction { @store[value] }
    @content = "The value is #{retrieved_value}"
    @status_code = 200
  end
end
