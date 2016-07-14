module Zedryx
  module Eval
    extend Discordrb::Commands::CommandContainer
    command(:eval, help_available: false) do |event, *code|
      break unless event.user.id == OWNER
      begin
        eval code.join(' ')
      rescue => e
        "An error occured 😞 ```#{e}```"
      end
    end
  end
end
