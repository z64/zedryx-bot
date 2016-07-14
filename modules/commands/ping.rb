module Zedryx
  module Ping
    extend Discordrb::Commands::CommandContainer
    command(:ping) do |event|
      event << 'Pong! :wink:'
    end
  end
end
