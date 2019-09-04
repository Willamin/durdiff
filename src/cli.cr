require "option_parser"
require "./durdiff"

parser = OptionParser.new do |parser|
  parser.banner = "usage: durdiff"

  parser.on("-v", "--version", "display the version") { puts Durdiff::VERSION; exit 0 }
  parser.on("-h", "--help", "show this help") { puts parser; exit 0 }
end

parser.parse!
