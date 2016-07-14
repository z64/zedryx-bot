module Zedryx
  module Ready
    extend Discordrb::EventContainer
    ready do |event|
    	Discordrb::LOGGER.info "bot ready"
    	event.bot.game = CONFIG['game']
    	event.bot.send_message(DEBUGCHANNEL, ":ok:")
    	avatar = File.open('media/avatar.jpg','rb')
    	event.bot.profile.avatar = avatar
    end
  end
end
