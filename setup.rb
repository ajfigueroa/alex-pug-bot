# frozen_string_literal: true

require 'pug'
require_relative './actions/imgify_action'
require_relative './actions/jira_format_action'

client_type = if ARGV[0] == 'telegram'
                Pug::Configuration::TELEGRAM
              else
                Pug::Configuration::TERMINAL
              end
actions = [ImgifyAction.new, JiraFormatAction.new]

Pug.configure do |config|
  config.type = client_type
  config.token = ENV['TELEGRAM_TOKEN']
  config.chat_id = ENV['TELEGRAM_CHAT_ID']
  config.actions = actions
end

Pug::Bot.run
