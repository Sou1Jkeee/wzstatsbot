require 'telegram/bot'

LIB_DIR = "#{__dir__}/lib".freeze
GLOB_PATTERN = '*.rb'.freeze

Dir.glob(File.join(LIB_DIR, GLOB_PATTERN)).each do |file|
  require_relative "#{LIB_DIR}/#{File.basename(file)}"
end

BotController.run