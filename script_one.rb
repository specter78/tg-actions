require 'telegram/bot'

token = ENV["BOT"]
chat_id = ENV["CHAT"]
bot = Telegram::Bot::Client.new(token)

# stock > price
stocks = [['WCIL', 165], ['HYUNDAI', 1940]]
stocks.each do |stock, price|
  output = File.read(stock + '.txt').split("\n")[0..-14]
  exit if output[3].split("'")[1].split(" ")[1] == "16:00:00"
  exit if output[19].split(' ')[-2].to_i < price
  caption = "#{stock} - \u20B9#{output[19].split(' ')[-2]}\n#{output[-2]}\n#{output[3].split("'")[1]}"
  path_to_photo = File.expand_path("./#{stock}.png")
  bot.api.send_photo(chat_id: chat_id, photo: Faraday::UploadIO.new(path_to_photo, 'image/png'), caption: caption)
end

# stock < price
# stocks = [['MAXPOSURE', 80], ['APS', 350]]
# stocks.each do |stock, price|
#   output = File.read(stock + '.txt').split("\n")[0..-14]
#   exit if output[3].split("'")[1].split(" ")[1] == "16:00:00"
#   exit if output[19].split(' ')[-2].to_i > price
#   caption = "#{stock} - \u20B9#{output[19].split(' ')[-2]}\n#{output[-2]}\n#{output[3].split("'")[1]}"
#   path_to_photo = File.expand_path("./#{stock}.png")
#   bot.api.send_photo(chat_id: chat_id, photo: Faraday::UploadIO.new(path_to_photo, 'image/png'), caption: caption)
# end
