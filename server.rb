require 'socket'               # Get sockets from stdlib

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
  match = /(\w+)\s(\/\w+.\w+)\s(\w+\/\d+.\d+)/.match(request)
  #puts match[1]
  #puts match[2]
  case match[1] 
    when 'GET'
      process_get(match[2], client)
    else
  end
  client.close                 # Disconnect from the client
}