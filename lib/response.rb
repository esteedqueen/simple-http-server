class Response
  def initialize(conn_sock, request)
    @conn_sock = conn_sock
    @request = request
    @path = (Dir.getwd + @request.path).gsub!(/\.+/, '.')

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
    if root_path
      load_homepage
    elsif File.exist?(@path)
      load_file
    else
      load_404
    end

    p "#{@request.method} #{@request.path} - #{@status_code}"

    parse_response(client_conn_socket, @status_code, @content)
  end

  def root_path
    @path.nil?
  end

  def load_homepage
    @content = File.binread('index.html')
    @status_code = 200
  end

  def load_file
    @content = if File.executable?(@path)
                 `#{@path}`
               else
                 File.binread(@path)
               end
    @status_code = 200
  end

  def load_404
    @content = 'File not found'
    @status_code = 404
  end
end
