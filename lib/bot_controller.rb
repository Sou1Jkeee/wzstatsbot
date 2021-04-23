require 'telegram/bot'

class BotController
  BOT_TOKEN = ENV['BOT_TOKEN']

  def initialize
    @bot = Telegram::Bot::Client
    @listen = listen
  end

  def listen
    @bot.run(BOT_TOKEN) do |bot|
      bot.listen do |message|
        case message
        when '/start', '/help'
          bot.api.send_message(
            chat_id: message.chat.id,
            text: "Здравствуй, #{message.from.username}\n" \
                  "Для того чтобы получить свежую статистику отправь мне свой ник в Xbox Live"
          )
        else
          begin
          user = username(message[:text])
          stats = parse_stats(create_link(user))

          bot.api.send_message(
            chat_id: message.chat.id,
            text: "Статистика пользователя #{user.gsub('%20', ' ')}:\n#{stats}"
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

  private

  def username(user)
    user.split.join('%20')
  end

  def create_link(username, platform = 'xbl')
    "https://cod.tracker.gg/warzone/profile/#{platform}/#{username}/detailed"
  end

  def parse_stats(link)
    StatsParser.parse_data(link)
  end
end
