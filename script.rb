
array = ['MANDEEP']

if array.length > 0
  system('npm i -g stock-nse-india')
  system('yarn global add carbon-now-cli')
end

array.each do |stock|
  output = `nseindia equity #{stock}`
  price = output.split("\n")[19].split(' ')[-2]
  caption = stock + " - " + price
  system("#{output} | carbon-now --save-as=output")
  url = `curl -F'file=@output.png' https://0x0.st`
  system("curl 'https://api.telegram.org/bot$BOT/sendPhoto?chat_id=-$CHAT&photo=$URL&caption=#{caption}'")
end

