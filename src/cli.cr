require "option_parser"
require "./durdiff"

parser = OptionParser.new do |parser|
  parser.banner = "usage: durdiff"

  parser.on("-v", "--version", "display the version") { puts Durdiff::VERSION; exit 0 }
  parser.on("-h", "--help", "show this help") { puts parser; exit 0 }

  parser.on("-a", "--all", "include hidden files") { Durdiff.show_all = true }
  parser.on("-e", "--expand", "show expanded paths") { Durdiff.expand_paths = true }

  parser.unknown_args { |args| ARGV.replace(args) }
end

parser.parse!

# main

left, right = Durdiff.get_lists

box = Durdiff::Box::QuadBox.new(
  left.path,
  right.path,
  left.entries.join("\n"),
  right.entries.join("\n")
)
box.draw(STDOUT)
