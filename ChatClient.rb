require 'socket'

@threads = []   # an array of threads

def createConnection(serverAddress, portNumber)               # connect to the server
  puts "\nConnecting to #{serverAddress}: #{portNumber}\n\n"
  begin
    $socket = TCPSocket.new(serverAddress, portNumber)
  rescue
    puts "server not available"
  end
end

def prepareForConnection    # grab inputs from the user
  puts "Welcome to Fernando's Ruby-Chat"
  puts "Please enter the server IP address"

  puts "\nPlease enter the server's IP"
  @serverAddress = STDIN.gets.chomp!

  puts "\nPlease enter the port number"
  @portNumber = STDIN.gets.chomp!

  puts "\nPlease enter your nickname"
  @nickname = STDIN.gets.chomp!
end


def sendMessages    # method to send messages

  begin
    @threads << Thread.new do

      while true
        message = STDIN.gets.chomp!

        if message.downcase == "exit"
          puts "Disconnected from the server"
          $socket.puts(message)
          @threads.each {|thread| thread.exit}
          exit(0)
        end

        $socket.puts("#{@nickname}: #{message}")
      end

  end

  rescue
    puts "I cannot send this message... Disconnected from the server"
  end

end


def getMessages     # method to receive messages

  begin
    @threads << Thread.new do

      loop do
        message = $socket.gets.chomp!
        puts "#{message}\n"
      end

    end

  rescue
    puts "Disconnected from the server"
  end

end


def runClient     # call all the methods and join the threads
  prepareForConnection
  createConnection(@serverAddress, @portNumber)
  getMessages
  sendMessages
  @threads.each {|thread| thread.join }
end


begin

  runClient

rescue

  puts "Closing the client..."

end
