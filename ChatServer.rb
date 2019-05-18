require 'socket'

@allClients = [] # an array of threads

@server = TCPServer.open("10.1.1.3", 50800)   # initialize the socket
puts "The server is now online...\nWaiting for clients\n"


def receiveMessages(client)   # handle client's messages

  begin

    loop do
      messageFromClient = client.gets
      puts "Message from #{client}"

      if messageFromClient.downcase.chomp! == "exit"
        puts "disconnecting #{client}"
        @allClients.delete(client)
        client.close
        Thread.exit
      end

      puts "#{messageFromClient}\n"

      @allClients.each do |user|
        user.puts("#{messageFromClient}\n")
      end

    end

  rescue
    puts "ops... you broke me"
    @server.close
  end

end


def runServer

  loop do

    Thread.start(@server.accept) do |client|
      @allClients << client

      puts "New client connected: #{client}"
      client.puts "Welcome to my server"
      client.puts "Connected at  #{Time.now}"
      client.puts "\nPlease enter the message or exit to leave:"

      receiveMessages(client)

    end

  end

end


begin
  runServer
rescue
  puts "Something went wrong... closing the server"
  @server.close
end
