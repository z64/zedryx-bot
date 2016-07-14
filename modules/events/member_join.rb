module Zedryx
  module Join
    extend Discordrb::EventContainer
    member_join do |event|

      #leave a message in leadership chat
      channel = event.server.text_channels.select { |c| c.name == event.bot.profile.name.downcase }.first
      event.bot.channel(channel).send_message("#{event.user.mention} has joined **#{event.server.name}**! :heart:")

      #log
      Discordrb::LOGGER.info("user #{event.user.name} [#{event.user.id}] has joined #{event.server.name} [#{event.server.id}]")

      #recognize returning user
      sql_user = User[:discord_id => event.user.id]
      if !sql_user.nil?
        event.server.default_channel.send_message("Welcome! :heart:\nI know you! I'll set up your roles on this server for **Team #{sql_user.team.name.capitalize}**.")
        roles = Array.new
        roles << event.server.roles.select { |r| r.name == "Member" }.first
        roles << event.server.roles.select { |r| r.name.downcase == sql_user.team.name }.first
        event.user.on(event.server).add_role roles
        return
      end

      #welcome message
      event.server.default_channel.send_message(
        "Welcome to **#{event.server.name}**, #{event.user.mention}!\nPlease tell me what team you're on like this:\n\n`team instinct`\n\nIf you need help, message anyone with the `Moderator` tag!"
      )

      #create new user
      sql_user = User.create(discord_id: event.user.id, name: event.user.name)

      event.user.await(:register, start_with: /[Tt]eam / ) do |subevent|

        #parse message
        message = subevent.message.content.split(" ").map(&:strip)

        #roles container
        roles = Array.new

        #add guest role
        roles << event.server.roles.select { |r| r.name == "Member" }.first

        team = Team[:name => message[1].downcase]
        if team.nil?
          subevent.channel.send_message("I didn't recognize that team..\nAsk a mod to help set your team up.")
        else
          roles << event.server.roles.select { |r| r.name.downcase == team.name }.first
          team.add_user sql_user
          team.save
        end

        subevent.user.on(event.server).add_role roles
        subevent.channel.send_message("Thanks! :smile:\nBe sure to read our `#rules`, and enjoy your stay!")
        false
      end
    end
  end
end
