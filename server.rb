#! /usr/bin/env ruby

require 'socket'
require_relative 'connection'

Request = Struct.new(:method, :path, :headers)

def start
  socket = Socket.new(:INET, :STREAM)
  socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
  socket.bind(Addrinfo.tcp('127.0.0.1', 4000))
  socket.listen(0)

  client_conn_socket, _addr_info = socket.accept
  connection = Connection.new(client_conn_socket)

  request = read_request(connection)
  response(client_conn_socket, request)
end

def read_request(connection)
  request_line = connection.read_line
  method, path, _version = request_line.split(' ', 3)
  headers = {}
  loop do
    line = connection.read_line
    break if line.empty?
    key, value = line.split(/:\s*/, 2)
    headers[key] = value
  end
  Request.new(method, path, headers)
end

def prepare_response(client_conn_socket, status_code, content)
  status_text = {
    200 => 'OK',
    404 => 'Not Found'
  }.fetch(status_code)

  client_conn_socket.send("HTTP/1.1 #{status_code} #{status_text}\r\n", 0)
  client_conn_socket.send("Content-Length: #{content.length}\r\n", 0)
  client_conn_socket.send("\r\n", 0)
  client_conn_socket.send(content, 0)
end

def response(client_conn_socket, request)
  path = Dir.getwd + request.path
  if File.exist?(path.gsub!(/\.+/, "."))
    content = File.read(path)
    status_code = 200
  else
    content = 'File not found'
    status_code = 404
  end

  prepare_response(client_conn_socket, status_code, content)
end

start