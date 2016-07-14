module Zedryx
  module Leave
    extend Discordrb::EventContainer
    member_leave do |event|
      user_sql = User[:discord_id => event.user.id]
      message = String.new
      if !user_sql.team.nil?
        message = "**#{event.user.name}** (#{user_sql.team.name}) has left the server! :confused:"
      else
        message = "**#{event.user.name}** has left the server! :confused:"
      end
      channel = event.server.text_channels.select { |c| c.name == event.bot.profile.name.downcase }.first
      event.bot.channel(DEBUGCHANNEL).send_message message
      Discordrb::LOGGER.info "#{event.user.name} [#{event.user.id}] has left server #{event.server.name} [#{event.server.id}]"
      if event.bot.user(event.user.id).nil?
        user_sql.delete
      end
    end
  end
end
