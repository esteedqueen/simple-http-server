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

    loop do
      socket.listen(0)
      p 'Server started: listening...'

      Thread.start(socket.accept) do |client_conn_socket, _addr_info|
        connection = Connection.new(client_conn_socket)

        request = RequestParser.new(connection).request
        Response.new(request, client_conn_socket).prepare

        sleep 1
        client_conn_socket.close
      end
    end
  end
end
