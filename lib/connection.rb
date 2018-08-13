class Connection
  def initialize(conn_socket)
    @conn_socket = conn_socket
    @buffer = ''
  end

  def read_line
    read_until("\r\n")
  end

  def read_until(string)
    until @buffer.include?(string)
      @buffer += @conn_socket.recv(7)
    end

    result, @buffer = @buffer.split(string, 2)
    result
  end
end
