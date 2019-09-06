require "digest/md5"

require "stdimp/string/puts"

require "./extensions"
require "./box"

module Durdiff
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end

module Durdiff
  class_property show_all : Bool = false
  class_property expand_paths : Bool = false
  class_property compute_digest : Bool = true
  class_property full_digest : Bool = false

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

    eleft = Durdiff.expand(left)
    eright = Durdiff.expand(right)

    left_list = Durdiff.list(eleft)
    right_list = Durdiff.list(eright)

    if Durdiff.expand_paths
      left = eleft
      right = eright
    end

    if Durdiff.compute_digest
      left_list = left_list.map { |e| "%s %s" % {e, Durdiff.short_hash(eleft + "/" + e)} }
      right_list = right_list.map { |e| "%s %s" % {e, Durdiff.short_hash(eright + "/" + e)} }
    end

    {
      DirAndEntries.new(left, left_list),
      DirAndEntries.new(right, right_list),
    }
  end

  def self.short_hash(filename : String) : String
    unless File.file?(filename)
      return ""
    end

    io = File.new(filename)
    size = File.size(filename)

    digest = Digest::MD5.hexdigest do |ctx|
      size.times do
        slice = Bytes.new(1)
        io.read(slice)
        ctx.update(slice)
      end
    end

    return digest if Durdiff.full_digest

    digest
      .chars
      .first(6)
      .join
      .tap { |d| "(%s)" % d }
  end
end
