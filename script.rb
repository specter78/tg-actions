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
  output = `nseindia equity #{stock}`
  caption = stock + " - " + output.split("\n")[19].split(' ')[-2]
  File.write("output.txt", output)
  system('carbon-now output.txt --save-as=output')
  
  path_to_photo = File.expand_path('./output.png')
  bot.api.send_photo(chat_id: chat_id, photo: Faraday::UploadIO.new(path_to_photo, 'image/png'))
end

