require "stdimp/string/puts"

require "./extensions"
require "./box"

module Durdiff
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end

module Durdiff
  class_property show_all : Bool = false

  def self.expand(dirname : String) : String
    dirname
      .file.expand_path
      .file.real_path
  end

  def self.list(dirname : String) : Array(String)
    dirname
      .dir
      .entries
      .sort
      .reject(&->(x : String) { !show_all && x.starts_with?(".") })
  end

  struct DirAndEntries
    property path : String
    property entries : Array(String)

    def initialize(@path, @entries); end
  end

  def self.get_lists : Tuple(DirAndEntries, DirAndEntries)
    left = ARGV[0]?
    right = ARGV[1]?

    if left.nil? || right.nil?
      STDERR.puts("You must provide two arguments")
      exit 1
    end

    left = Durdiff.expand(left)
    right = Durdiff.expand(right)

    left_list = Durdiff.list(left)
    right_list = Durdiff.list(right)

    {
      DirAndEntries.new(left, left_list),
      DirAndEntries.new(right, right_list),
    }
  end
end
