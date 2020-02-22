require "kemal"
require "ssh2"
require "option_parser"

OptionParser.parse do |parser|
  parser.banner = "Usage: xterm [arguments]"

  parser.on "-s", "--server", "Run server" do
    host = ENV.fetch("HOST")
    user = ENV.fetch("USER")
    password = ENV.fetch("PASSWORD")

    ws "/" do |socket|
      socket.on_message do |command|
        output = IO::Memory.new

        SSH2::Session.open(host) do |session|
          session.login(user, password)
          session.open_session do |channel|
            channel.command(command)
            IO.copy(channel, output)
          end
        end

        socket.send output.to_s
      end
    end

    Kemal.run
  end
  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end
