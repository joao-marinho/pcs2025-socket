require 'socket'
require 'transfer'

class Server

	def initialize(port, file_to_transfer = 'README.md')
			@port = port
			@file_to_transfer = file_to_transfer
	end

	def run

		server = TCPServer.new @port # Server bind to port 2000
		count = 1;

		loop do
			Thread.start(server.accept) do |client|

				client_id = count
			  p "Client #{client_id} - init"

			  file = File.open(@file_to_transfer, 'r')
			  
			  transfer = Transfer.new(file, client)
			  transfer.run

			  # client.puts "Client #{client_id}, Time is #{Time.now}"

			  client.close	
			  file.close
			  p "Client #{client_id} - done"

		  end

			count += 1
		end

	end
	
	
end