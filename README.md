# Simple HTTP Server

An experiment on building an http server from scratch.

This is a simple HTTP server with minimal features (obviously non spec compliant), built with Ruby using the [Socket](https://ruby-doc.org/stdlib-2.5.1/libdoc/socket/rdoc/Socket.html) class available in Ruby’s standard library.

# Prerequisites
To run the server locally, you're going to need:

[Ruby](https://www.ruby-lang.org/en/documentation/installation/), I'm running version 2.5.1p57

# Getting started

Clone the repo and `cd` to the working directory

```bash
git clone git@github.com:esteedqueen/simple-http-server.git

cd simple-http-server
```

Start the server

1. On the default port `4000`

```bash
bin/start
```

OR

2. Specify your preferred port using `-p` or `-port` flags

```bash
bin/start -p 3000

OR

bin/start -port 8000
```

# Features

## Homepage

Test via curl or open in browser:

```bash
curl "127.0.0.1:4000/"

OR

open "127.0.0.1:4000/"
```


## Read content of existing file

Test via curl or open in browser:

```bash
curl "127.0.0.1:4000/hello.txt"

OR

open "127.0.0.1:4000/hello.txt"
```

## Execute scripts in executable file

Test via curl or open in browser:

```bash
curl "127.0.0.1:4000/hello.rb"

OR

open "127.0.0.1:4000/hello.rb"
```

## Query parsing

### Store a record: `/set?somekey=somevalue`
Test via curl or open in browser:

```bash
curl "127.0.0.1:4000/set?name=Bolatito"

OR

open "127.0.0.1:4000/set?name=Bolatito"
```

### Retrieve a record: `/get?key=somekey`

```bash
curl "127.0.0.1:4000/get?key=name"

OR

open "127.0.0.1:4000/get?key=name"
```

## Handle file not found

Test via curl or open in browser:

```bash
curl "127.0.0.1:4000/hello.py"

OR

open "127.0.0.1:4000/hello.py"
```