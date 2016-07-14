module Zedryx
  module Log
    extend Discordrb::EventContainer
    message do |event|
      Discordrb::LOGGER.info "[#{event.server.name} | #{event.message.channel.name} : #{event.user.name}] #{event.message.content}"
      Chatlog.create(
        server_id:    event.server.id,
        server_name:  event.server.name,
        channel_id:   event.channel.id,
        channel_name: event.channel.name,
        discord_id:   event.user.id,
        user_name:    event.user.name,
        message_content: event.message.content
      )
    end
  end
end
