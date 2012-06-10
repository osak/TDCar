require_relative 'vector2d'

def discritize(x, factor)
  (x / factor).to_i
end

class Action
  attr_reader :l_force, :r_force, :id
  
  def eql?(other)
    @id == other.id
  end
  alias == eql?

  def hash
    @id
  end

  private
  def initialize(l_force, r_force, id)
    @l_force = l_force
    @r_force = r_force
    @id = id
  end

  class <<self
    @@actions = []
    id = 0
    (-5..5).each do |l|
      (-5..5).each do |r|
        if l.abs > 2 or r.abs > 2
          lv = Vector2D.new(0, l*0.1).freeze
          rv = Vector2D.new(0, r*0.1).freeze
          @@actions << Action.new(lv, rv, id).freeze
          id += 1
        end
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
  attr_reader :angle, :pos, :speed, :rotate_speed

  def initialize(env, angle, pos, speed, rotate_speed)
    @env = env
    @angle = discritize(angle, 90)
    @pos = Vector2D.new(discritize(pos.x, 100), discritize(pos.y, 100))
    @speed = Vector2D.new(discritize(speed.x, 0.3), discritize(speed.y, 0.3))
    @rotate_speed = discritize(rotate_speed, 2)
  end

  def next_state(action)
    @env.react(action)
  end

  def terminal?
    false
  end

  def eql?(other)
    #@angle == other.angle and @l_force == other.l_force and @r_force == other.r_force
    @angle == other.angle and @pos == other.pos and @speed == other.speed and @rotate_speed == other.rotate_speed
  end
  alias == eql?

  def hash
    #@angle * 100000 + @l_force.hash * 1000 + @r_force.hash
    @rotate_speed * 10000000 + @speed.norm * 100000 + @angle * 1000 + @pos.norm
  end

  def to_s
    "(#{@angle}, #{@pos})"
  end

  def marshal_dump
    [@angle, @pos, @speed, @rotate_speed]
  end

  def marshal_load(dat)
    @angle, @pos, @speed, @rotate_speed = *dat
  end
end
