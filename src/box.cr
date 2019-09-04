module Durdiff::Box
  HORIZONTAL   = "─"
  VERTICAL     = "│"
  TOP_LEFT     = "┌"
  TOP_RIGHT    = "┐"
  BOTTOM_LEFT  = "└"
  BOTTOM_RIGHT = "┘"
  TOP_JOINT    = "┬"
  BOTTOM_JOINT = "┴"
  RIGHT_JOINT  = "┤"
  LEFT_JOINT   = "├"
  CENTER       = "┼"
end

class Durdiff::Box::Simple
  @margin = 1
  @width : Int32

  def initialize(@content : String)
    @width = @content.lines.max_by(&.size).size
  end

  def draw(io : IO)
    io << TOP_LEFT
    io << HORIZONTAL * (@margin + @width + @margin)
    io << TOP_RIGHT
    io << "\n"

    @content.lines.each do |line|
      io << VERTICAL
      io << " " * @margin
      io << line
      io << " " * (@width - line.size)
      io << " " * @margin
      io << VERTICAL
      io << "\n"
    end

    io << BOTTOM_LEFT
    io << HORIZONTAL * (@margin + @width + @margin)
    io << BOTTOM_RIGHT
    io << "\n"
  end
end

class Durdiff::Box::VSplitBox
  @margin = 1
  @width_left : Int32
  @width_right : Int32

  def initialize(@content_left : String, @content_right : String)
    @width_left = @content_left.lines.max_by(&.size).size
    @width_right = @content_right.lines.max_by(&.size).size
  end

  def draw(io : IO)
    io << TOP_LEFT
    io << HORIZONTAL * (@margin + @width_left + @margin)
    io << TOP_JOINT
    io << HORIZONTAL * (@margin + @width_right + @margin)
    io << TOP_RIGHT
    io << "\n"

    [@content_left, @content_right].map(&.lines).max_by(&.size).size.times do |row|
      left = @content_left.lines[row]? || ""
      right = @content_right.lines[row]? || ""
      io << VERTICAL
      io << " " * @margin

      io << left
      io << " " * (@width_left - left.size)

      io << " " * @margin
      io << VERTICAL
      io << " " * @margin

      io << right
      io << " " * (@width_right - right.size)

      io << " " * @margin
      io << VERTICAL
      io << "\n"
    end

    io << BOTTOM_LEFT
    io << HORIZONTAL * (@margin + @width_left + @margin)
    io << BOTTOM_JOINT
    io << HORIZONTAL * (@margin + @width_right + @margin)
    io << BOTTOM_RIGHT
    io << "\n"
  end
end

class Durdiff::Box::QuadBox
  @margin = 1
  @width_left : Int32
  @width_right : Int32

  def initialize(@content_topleft : String, @content_topright : String,
                 @content_bottomleft : String, @content_bottomright : String)
    @width_left = [@content_topleft, @content_bottomleft]
      .map(&.lines)
      .tap(&->(a : Array(Array(String))) { a[0].concat(a[1]) })
      .[0]
      .max_by(&.size)
      .size

    @width_right = [@content_topright, @content_bottomright]
      .map(&.lines)
      .tap(&->(a : Array(Array(String))) { a[0].concat(a[1]) })
      .[0]
      .max_by(&.size)
      .size
  end

  def draw(io : IO)
    io << TOP_LEFT
    io << HORIZONTAL * (@margin + @width_left + @margin)
    io << TOP_JOINT
    io << HORIZONTAL * (@margin + @width_right + @margin)
    io << TOP_RIGHT
    io << "\n"

    [{@content_topleft, @content_topright},
     {nil, nil},
     {@content_bottomleft, @content_bottomright}]
      .each do |left, right|
        if left == nil || right == nil
          io << LEFT_JOINT

          io << HORIZONTAL * @margin
          io << HORIZONTAL * @width_left
          io << HORIZONTAL * @margin

          io << CENTER

          io << HORIZONTAL * @margin
          io << HORIZONTAL * @width_right
          io << HORIZONTAL * @margin

          io << RIGHT_JOINT

          io << "\n"
        end

        left = left || ""
        right = right || ""

        height = [left, right]
          .map(&.lines)
          .max_by(&.size)
          .size

        height.times do |row|
          left_line = left.lines[row]? || ""
          right_line = right.lines[row]? || ""

          io << VERTICAL
          io << " " * @margin

          io << left_line
          io << " " * (@width_left - left_line.size)

          io << " " * @margin
          io << VERTICAL
          io << " " * @margin

          io << right_line
          io << " " * (@width_right - right_line.size)

          io << " " * @margin
          io << VERTICAL
          io << "\n"
        end
      end

    io << BOTTOM_LEFT
    io << HORIZONTAL * (@margin + @width_left + @margin)
    io << BOTTOM_JOINT
    io << HORIZONTAL * (@margin + @width_right + @margin)
    io << BOTTOM_RIGHT
    io << "\n"
  end
end
