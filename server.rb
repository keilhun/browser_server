require 'socket'               # Get sockets from stdlib
require 'json'
require 'pp'

def process_post(request, client)
  params = {}
  while request != ""
    request = client.gets
    command, data = request.split(':')
    if command == "Content-Length"
        data_length = data.to_i
        request = client.gets  #consume blank line
        request = client.read(data_length)
        params = JSON.parse(request)
        break
    end
  end
  text = File.read("thanks.html")
  first,last = text.split("<%= yield %>")
  replacement = ""
  params.each do |key, value|
    value.each do |key2, value2|
      replacement = replacement + "<li>#{key2}: #{value2}</li>"
    end
  end
  output = first + replacement + last
  client.puts("HTTP/1.0 200 OK")
  client.puts("Content-Type: text/html")
  client.puts("Content-Length: #{output.length}")
  client.puts("")
  client.puts(output)
end

def process_get(file, client)
  file = "." + file
  if File.exists?(file)
    lines = File.readlines(file)
    client.puts("HTTP/1.0 200 OK")
    bytes = lines.to_s.length
    client.puts("Content-Type: text/html")
    client.puts("Content-Length: #{bytes}")
    client.puts("")
    lines.each do |line|
      client.puts(line)
    end
  else
    client.puts("HTTP/1.0 404 File Not Found")
  end
end

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect
  #client.puts(Time.now.ctime)  # Send the time to the client 
 #client.puts "Closing the connection. Bye!"
  request = client.gets
  print "request = #{request}"
  match = /(\w+)\s(\/\w+.\w+)\s(\w+\/\d+.\d+)/.match(request) #This matches the first header line 
  case match[1] 
    when 'GET'
      process_get(match[2], client)
    when 'POST'
      process_post(request,client)
    else
  end
  client.close                 # Disconnect from the client
}