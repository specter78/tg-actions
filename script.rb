require 'telegram/bot'

token = ENV["BOT"]
chat_id = ENV["CHAT"]
bot = Telegram::Bot::Client.new(token)

stocks = ['MANDEEP']
if stocks.length > 0
  system('npm i -g stock-nse-india')
  system('yarn global add carbon-now-cli')
end

stocks.each do |stock|
  system("nseindia equity #{stock} | carbon-now --save-as=output")
  output = `nseindia equity #{stock}`
  caption = "#{stock} - ₹#{output.split("\n")[19].split(' ')[-2]}\n#{output.split("\n")[-2]}\n#{output.split("\n")[3].split(''')[1]}"
  path_to_photo = File.expand_path('./output.png')
  bot.api.send_photo(chat_id: chat_id, photo: Faraday::UploadIO.new(path_to_photo, 'image/png'), caption: caption)
end
