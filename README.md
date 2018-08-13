# Simple HTTP Server

A simple HTTP server with minimal features built with Ruby using the (Socket)[https://ruby-doc.org/stdlib-2.4.0/libdoc/socket/rdoc/Socket.html] class available in Ruby’s standard library.

# Prerequisite

Install Ruby.

# Start the server

- Clone the repo and cd to the working directory

```bash
git clone

cd simple-http-server
```

- On the default port `4000`

```bash
bin/start
```

- On your preferred port

```bash
bin/start -p 3000
```

OR

```bash
bin/start -p 8000
```

# Features

## Homepage

- Via curl:

```bash
curl "127.0.0.1:4000/"
```

- Open in a browser:

```bash
open "127.0.0.1:4000/"
```

## Read content of existing file
- Via curl:

```bash
curl "127.0.0.1:4000/hello.txt"
```

- Open in a browser:

```bash
open "127.0.0.1:4000/hello.txt"
```

## Read executable file
- Via curl:

```bash
curl "127.0.0.1:4000/hello.rb"
```

- Open in a browser:

```bash
open "127.0.0.1:4000/hello.rb"
```

## Handle file not found
- Via curl:

```bash
curl "127.0.0.1:4000/hello.py"
```

- Open in a browser:

```bash
open "127.0.0.1:4000/hello.py"
```