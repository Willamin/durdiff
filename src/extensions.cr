class String
  def file
    File.new(self)
  end

  def dir
    Dir.new(self)
  end
end

class File
  def expand_path
    File.expand_path(@path)
  end

  def real_path
    File.real_path(@path)
  end
end
