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

left_set = Set.new(left.entries)
right_set = Set.new(right.entries)
joint = left_set | right_set

sorted_left =
  joint
    .to_a
    .sort
    .map { |x| Set{x} }
    .map { |x| x & left_set }
    .map(&.first?)
    .map { |x| x || "" }

sorted_right =
  joint
    .to_a
    .sort
    .map { |x| Set{x} }
    .map { |x| x & right_set }
    .map(&.first?)
    .map { |x| x || "" }

box = Durdiff::Box::QuadBox.new(
  left.path,
  right.path,
  sorted_left.join("\n"),
  sorted_right.join("\n")
)
box.draw(STDOUT)
