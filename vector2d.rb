class Vector2D
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def dup
    Vector2D.new(@x, @y)
  end

  def eql?(other)
    @x == other.x and @y == other.y
  end
  alias == eql?

  def norm
    @x*@x + @y*@y
  end

  def +(other)
    Vector2D.new(@x+other.x, @y+other.y)
  end

  def -@
    Vector2D.new(-@x, -@y)
  end

  def -(other)
    Vector2D.new(@x-other.x, @y-other.y)
  end

  def *(num)
    Vector2D.new(@x*num, @y*num)
  end

  def cross(other)
    @x*other.y - @y*other.x
  end

  def rotate(rad)
    res = self.dup
    res.rotate!(rad)
    res
  end

  def rotate!(rad)
    cos = Math.cos(rad)
    sin = Math.sin(rad)
    curx = @x
    cury = @y
    @x = curx*cos - cury*sin
    @y = curx*sin + cury*cos
  end

  def to_s
    "(#{@x},#{@y})"
  end

  def inspect
    "Vector2D(#{@x},#{@y})"
  end
end


