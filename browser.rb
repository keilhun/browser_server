require 'socket'
require 'json'

def process_post()
  viking = {}
  print "Enter Viking Name: "
  name = gets.chomp
  print "Enter Viking Email: "
  email = gets.chomp
  
  viking = {viking: {name: name, email: email}}
  viking_json = viking.to_json
  puts "json = #{viking_json}"
  request = "POST /index.html http/1.0\n"
  request = request + "Content-Type: application/json\n"
  request = request + "Content-Length: #{viking_json.length}\n\n"
  request = request + viking_json
  return request
end

host = 'localhost'     # The web server
#port = 80                           # Default HTTP port
port = 2000
path = "/index.htm"                 # The file we want 

print "Do you want to send a GET or POST request: "
type = gets.chomp.upcase

case type
  when "GET"
    request = "GET #{path} HTTP/1.0\r\n\r\n"
  when "POST"
    request = process_post()
end

# This is the HTTP request we send to fetch a file
#request = "GET #{path} HTTP/1.0\r\n\r\n"

#print request
socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers,body = response.split("\n\n", 2)
header_lines = headers.split("\n")
# match[1]=transport type, match[2]=result code, match[3]=Result Message
match = /(\w+\/\d.\d)\s(\d+)\s(.+)/.match(header_lines[0])

case match[2]
  when "200"
    puts body
  else
    puts match[3]
end