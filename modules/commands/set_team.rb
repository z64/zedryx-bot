module Zedryx
  module SetTeam
    extend Discordrb::Commands::CommandContainer
    command(:setteam,
            required_permissions: [:manage_roles],
            min_args: 2,
            description: "Updates a user's team.",
            usage: "setteam @user [new power]"
    ) do |event, user, *name|
      break unless event.user.id == OWNER
      name = name.join(' ')

      discord_user = event.bot.parse_mention(user).on(event.server)
      sql_user     = User[:discord_id => discord_user.id]
      add_roles    = Array.new
      remove_roles = Array.new

      old_power = sql_user.power
      if !old_power.nil?
        remove_roles << event.server.roles.select { |p| p.name == old_power.name              }.first
        remove_roles << event.server.roles.select { |p| p.name == old_power.superfaction.name }.first
      end

      new_power = Power.all.select { |p| p.name.downcase == name.downcase }.first
      if new_power.nil?
        event << "Power not found: `#{name}`"
        return
      else
        add_roles << event.server.roles.select { |p| p.name == new_power.name              }.first
        add_roles << event.server.roles.select { |p| p.name == new_power.superfaction.name }.first
        if new_power.name == POWER
          add_roles << event.server.roles.select { |r| r.name == "unverified" }.first
        end
      end

      role_verified = event.server.roles.select  { |r| r.name == "verified" }.first

      if discord_user.role?(role_verified)
        remove_roles << role_verified
      end

      discord_user.remove_role remove_roles
      discord_user.add_role    add_roles
      sql_user.power =         new_power
      sql_user.save

      Discordrb::LOGGER.info "#{event.user.name} [#{event.user.id}] updated #{discord_user.name} [#{discord_user.id}] pledge status to #{new_power.name}"
      event << "Updated! :wink:"
    end
  end
end
