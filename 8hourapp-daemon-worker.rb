#checks main repository and keeps the app repositories up to date
require 'yaml'
require 'logger'

$Logger = Logger.new '/Users/izevaka/src/8hourapp/log/daemon.log', 'daily'
$Logger.level = Logger::DEBUG

class AppDaemon
end
