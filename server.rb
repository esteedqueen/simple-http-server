#! /usr/bin/env ruby

require 'socket'

Request = Struct.new(:method, :path, :headers)

def main
  socket = Socket.new(:INET, :STREAM)
  socket.setsockopt(:SOL_SOCKET, :SO_REUSEADDR, true)
  socket.bind(Addrinfo.tcp('127.0.0.1', 4000))
  socket.listen(0)

  client_conn_socket, addr_info = socket.accept
  # puts client_conn_socket.recv(4096)
  respond(client_conn_socket, 200, 'Some content to the client')
end

def respond(client_conn_socket, status_code, content)
  status_text = {
    200 => 'OK',
    404 => 'Not Found'
  }.fetch(status_code)
  client_conn_socket.send("HTTP/1.1 #{status_code} #{status_text}\r\n", 0)
  client_conn_socket.send("Content-Length: #{content.length}\r\n", 0)
  client_conn_socket.send("\r\n", 0)
  client_conn_socket.send(content, 0)
end

main
