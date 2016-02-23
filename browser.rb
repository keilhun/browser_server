require 'socket'
require 'pp'

host = 'localhost'     # The web server
#port = 80                           # Default HTTP port
port = 2000
path = "/index.htm"                 # The file we want 

# This is the HTTP request we send to fetch a file
request = "GET #{path} HTTP/1.0\r\n\r\n"

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

#pp header_lines
#print headers
#print body                          # And display it