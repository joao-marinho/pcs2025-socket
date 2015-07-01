require 'socket'
require 'transfer'

class Client 

  def initialize(ip, port, file_name = "./test/produced#{rand(1000000000)}.png")
    @ip = ip
    @port = port
    @file_name = file_name
  end

  def run 
    # Thread.new do
      clientSocket = TCPSocket.new @ip, @port
      p "Connected"
      file = File.open(@file_name, 'w')

      t = Transfer.new(clientSocket, file)
      t.run

      clientSocket.close 
      file.close
    # end
  end

end


