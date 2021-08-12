require 'telegram/bot'

class BotController
  class << self
    BOT_TOKEN = ENV['BOT_TOKEN']

    def run
      @bot = Telegram::Bot::Client
      listen
    end

    def listen
      @bot.run(BOT_TOKEN) do |bot|
        bot.listen do |message|
          begin
            case message[:text]
            when '/start', '/help'
              bot.api.send_message(
                chat_id: message[:chat][:id],
                text: "Здравствуй, #{message[:from][:username]}\n" \
                      "Для того чтобы получить свежую статистику отправь мне свой ник в Xbox Live"
              )
            else
              username = fix_username(message[:text])
              stats = get_data(username)

              bot.api.send_message(
                chat_id: message[:chat][:id],
                text: "Статистика пользователя #{username.gsub('%20', ' ')}:\n#{stats}"
              )
            end
          rescue URI::InvalidURIError, NoMethodError
            bot.api.send_message(
              chat_id: message[:chat][:id],
              text: "Некорректный ник",
            )
          rescue OpenURI::HTTPError
            bot.api.send_message(
              chat_id: message[:chat][:id],
              text: "Пользователь не найден",
            )
          end
        end
      end
    end

    private

    def fix_username(user)
      user.split.join('%20')
    end
    
    def get_data(username)
      StatsParser.run(username)
    end
  end  
end
