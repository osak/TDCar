require_relative 'vector2d'

def descritize(x, factor)
  (x / factor).to_i
end

class Action
  attr_reader :l_force, :r_force
  
  def eql?(other)
    self.equal?(other)
  end
  alias == eql?

  def hash
    object_id
  end

  private
  def initialize(l_force, r_force)
    @l_force = l_force
    @r_force = r_force
  end

  class <<self
    @@actions = []
    (-10..10).each do |l|
      (-10..10).each do |r|
        lv = Vector2D.new(0, l*0.1).freeze
        rv = Vector2D.new(0, r*0.1).freeze
        @@actions << Action.new(lv, rv).freeze if lv.norm > 0.5 and rv.norm > 0.5
      end
    end
    @@actions.freeze

    def each(&block)
      @@actions.each(&block)
    end

    def all
      @@actions
    end
  end
end

class State
  attr_reader :angle, :pos

  def initialize(env, angle, pos)
    @env = env
    @angle = descritize(angle, 45)
    @pos = Vector2D.new(descritize(pos.x, 100), descritize(pos.y, 100))
  end

  def next_state(action)
    @env.react(action)
  end

  def terminal?
    false
  end

  def eql?(other)
    #@angle == other.angle and @l_force == other.l_force and @r_force == other.r_force
    @angle == other.angle and @pos == other.pos
  end
  alias == eql?

  def hash
    #@angle * 100000 + @l_force.hash * 1000 + @r_force.hash
    @angle * 1000 + @pos.x + @pos.y
  end

  def to_s
    "(#{@angle}, #{@pos})"
  end
end
