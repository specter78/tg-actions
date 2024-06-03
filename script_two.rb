require 'json'
require 'securerandom'
require 'telegram/bot'

rules = File.read('adblock/ios/adguard_annoyances_optimized.txt').split("\n") + \
        File.read('adblock/ios/adguard_base_optimized.txt').split("\n") +   \
        File.read('adblock/ios/adguard_mobile_optimized.txt').split("\n") + \
        File.read('adblock/ios/adguard_social_optimized.txt').split("\n") + \
        File.read('adblock/ios/adguard_tracking_protection_optimized.txt').split("\n") + \
        File.read('f9161fd2489c677e795256e5464338d1/custom_blocklist.txt').split("\n")
rules = rules.uniq.delete_if { |e| e == '' }
File.write('rules.txt', rules.join("\n"))

converted_rules = `cat rules.txt | ./ConverterTool --safari-version 17 --optimize false --advanced-blocking false --advanced-blocking-format txt`
converted_rules = JSON.parse converted_rules
converted_rules = JSON.parse converted_rules["converted"]

output = Hash.new
output["id"] = SecureRandom.uuid.upcase
output["name"] = "Custom Rules"
output["createdAt"] = 739022144.516709
output["rules"] = []

valid_resource_types = ['document', 'image', 'style-sheet', 'script', 'font', 'raw', 'svg-document', 'media', 'popup']
converted_rules.each do |rule|
  next if rule["action"]["type"] == "ignore-previous-rules"
  if rule["trigger"]["resource-type"]
    rule["trigger"]["resource-type"] = rule["trigger"]["resource-type"] & valid_resource_types
  end
  output["rules"] << { "name" => "", "id" => SecureRandom.uuid.upcase, "content" => rule }
end
File.write('Custom Rules.1blockpkg', JSON.pretty_generate([] << output))

token = ENV["BOT"]
chat_id = ENV["CHAT"]
bot = Telegram::Bot::Client.new(token)
path_to_file = File.expand_path("./Custom Rules.1blockpkg")
bot.api.send_document(chat_id: chat_id, document: Faraday::UploadIO.new(path_to_file, 'text/plain'))
