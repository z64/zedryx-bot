require 'discordrb'
require 'sequel'
require 'yaml'

#sqlite db
DB = Sequel.connect('sqlite://zedryx.db')
Sequel.extension :migration
Sequel::Migrator.run(DB, "modules/sequel/migrations")

#config file
CONFIG = YAML.load(File.read('config.yaml'))

#check that we're configured properly
CONFIG.each do |key, value|
  if value.nil?
    puts "config.yaml: #{key} not supplied!"
    puts "Please completely fill out the config.yaml template and try again."
    exit
  elsif
    puts "config.yaml: Found #{key}: #{value}"
  end
end

module Zedryx

  #configuration
  APPID        = CONFIG['appid']
  TOKEN        = CONFIG['token']
  DEBUGCHANNEL = CONFIG['debugChannel']
  OWNER        = CONFIG['owner']
  PREFIX       = CONFIG['prefix']
  BOT_ID       = CONFIG['bot']

  # require modules
  Dir['modules/*.rb'].each          { |r| require_relative r ; puts "Loaded rb: #{r}" }
  Dir['modules/commands/*.rb'].each { |r| require_relative r ; puts "Loaded rb: #{r}" }
  Dir['modules/events/*.rb'].each   { |r| require_relative r ; puts "Loaded rb: #{r}" }
  Dir['modules/sequel/*.rb'].each   { |r| require_relative r ; puts "Loaded rb: #{r}" }
  modules = [
    Eval,
    Join,
    Leave,
    Log,
    Ping,
    Ready,
    SetTeam
  ]

  # setup bot
  bot = Discordrb::Commands::CommandBot.new(token: TOKEN, application_id: APPID, prefix: [PREFIX, "<@#{BOT_ID}> ", "<@!#{BOT_ID}> "])
  modules.each { |m| bot.include! m }

  bot.run
end
