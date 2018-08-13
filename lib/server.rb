require 'socket'
require_relative 'connection'
require_relative 'response'
require_relative 'request_parser'

class Server
  DEFAULT_PORT = 4000

  def initialize(port:)
    @port = port || DEFAULT_PORT
  end

  def start
    socket = Socket.new(:INET, :STREAM)
    socket.setsockopt(:SOL_SOCKET, :SO_REUSEADDR, true)
    socket.bind(Addrinfo.tcp('127.0.0.1', @port))

    loop {
      socket.listen(0)
      p 'Server started: listening...'

      client_conn_socket, _addr_info = socket.accept
      connection = Connection.new(client_conn_socket)

      request = RequestParser.new(connection).request
      Response.new(client_conn_socket, request)
      client_conn_socket.close
    }
  end
end
