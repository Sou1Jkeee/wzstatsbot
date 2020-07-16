require 'telegram/bot'
require_relative 'stats_parser.rb'

class BotController
  BOT_TOKEN = ENV['BOT_TOKEN']

  def initialize
    @bot = Telegram::Bot::Client
    @listen = listen
  end

  def listen
    @bot.run(BOT_TOKEN) do |bot|
      bot.listen do |message|
        case message.text
        when '/start', 'start', 'help', '/help'
          bot.api.send_message(
            chat_id: message.chat.id,
            text: "Здравствуй, #{message.from.username}\n" \
            "Для того чтобы получить свежую статистику отправь мне свой ник в Xbox Live"
          )
        else
          begin
          user = nickname(message.text)
          parser = StatsParser.new("https://cod.tracker.gg/warzone/profile/xbl/#{user}/overview")

          bot.api.send_message(
            chat_id: message.chat.id,
            text: "Статистика пользователя #{message.text}:\n#{parser.get_stats.join("\n")}"
          )
          rescue URI::InvalidURIError
            bot.api.send_message(
              chat_id: message.chat.id,
              text: "Некорректный ник",
            )
          rescue OpenURI::HTTPError
            bot.api.send_message(
              chat_id: message.chat.id,
              text: "Пользователь не найден",
            )
          end
        end
      end
    end
  end

  def nickname(nickname)
    nickname.split.join('%20')
  end
end
