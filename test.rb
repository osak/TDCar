#!/usr/bin/ruby

require 'sdl'
require 'narray'
require_relative 'fpscounter'
require_relative 'problem'
require_relative 'vector2d'
require_relative 'qlearning'
require_relative 'sarsa'

class Wheel
  def initialize(parent, pos)
    @parent = parent
    @pos = pos.freeze
  end

  def add_force(force)
    @parent.add_force(@pos, force)
  end
end

class Robot
  attr_reader :speed, :last_reward
  attr_accessor :pos, :angle, :left_wheel, :right_wheel

  def initialize(pos, w, h)
    @pos = pos.dup
    @w = w
    @h = h
    @speed = Vector2D.new(0, 0)
    @angle = 0
    @rotate_speed = 0

    @surface = SDL::Surface.new(SDL::HWSURFACE, @w, @h, SDL::Screen.get.format)
    @surface.lock
    @surface.fill_rect(0, 0, @w, @h, 0xffffff)
    @surface.put_pixel(10, 35, 0xff0000)
    @surface.put_pixel(40, 35, 0xff0000)
    @surface.unlock
  end

  def reset
    @pos = Vector2D.new(200, 400)
    @angle = 0
    @speed = Vector2D.new(0, 0)
    @rotate_speed = 0
  end

  def move
    @pos += @speed
    @angle += @rotate_speed
  end

  def draw(surface)
    surface.lock
    SDL::Surface.transform_draw(@surface, surface, @angle, 1, 1, @w/2, @h/2, @pos.x, @pos.y, SDL::Surface::TRANSFORM_SAFE)
    vec = @speed * 30
    surface.draw_line(@pos.x, @pos.y, @pos.x+vec.x, @pos.y+vec.y, 0xff0000)
    surface.unlock
  end

  def speed=(val)
    @speed = val
  end

  def accelarate(val)
    @speed += val
  end

  def add_force(pos, force)
    center = Vector2D.new(@w/2, @h/2)
    pos = center + (pos-center).rotate(@angle * Math::PI / 180)
    f = force.rotate(@angle * Math::PI / 180)
    @speed += f
    @rotate_speed += (pos-center).cross(f)
  end

  def react(action)
    @speed *= 0.3
    @rotate_speed *= 0.3
    add_force(@left_wheel, action.l_force)
    add_force(@right_wheel, action.r_force)
    prev_pos = @pos.dup
    move
    reward = @speed.norm-1.2
    unless (0..400).include?(@pos.x) and (0..400).include?(@pos.y)
      reward = -100000000000
      reset
    end
    @last_reward = reward
    [reward, current_state]
  end

  def current_state
    State.new(self, @angle, pos, @speed, @rotate_speed)
  end
end

SDL.init(SDL::INIT_VIDEO)
SDL::TTF.init
surface = SDL::Screen.open(400, 400, 32, SDL::HWSURFACE | SDL::DOUBLEBUF)
font = SDL::TTF.open("/usr/share/fonts/TTF/migmix-1m-bold.ttf", 14)
robot = Robot.new(Vector2D.new(200, 400), 50, 70)
robot.left_wheel = Vector2D.new(10, 35).freeze
robot.right_wheel = Vector2D.new(40, 35).freeze
#wheel1 = Wheel.new(robot, Vector2D.new(10, 35))
#wheel2 = Wheel.new(robot, Vector2D.new(40, 35))
fps_counter = FPSCounter.new
brain = QLearning.new(robot.current_state)
steps = 0

mode = :stop
catch(:exit) do
  loop do
    while event = SDL::Event.poll
      case event
      when SDL::Event::KeyDown
        throw :exit if event.sym == SDL::Key::Q
        if event.sym == SDL::Key::SPACE
          if mode == :learn
            mode = :greedy
          else
            mode = :learn
          end
        end
      end
    end

    if mode == :learn
      brain.do_step
      steps += 1
    elsif mode == :greedy
      robot.react(brain.greedy_decide(robot.current_state))
    end
=begin
    unless (0..400).include?(robot.pos.x) and (0..400).include?(robot.pos.y)
      robot.pos = Vector2D.new(200, 400)
      robot.angle = 0
      brain.reset(State.new(robot, 0, Action.all.first, Action.all.first))
    end
=end

    surface.lock
    surface.fill_rect(0, 0, 400, 400, 0)
    robot.draw(surface)
    surface.unlock

    font.draw_solid_utf8(surface, "FPS: #{fps_counter.fps}", 0, 0, 0xff, 0xff, 0xff)
    font.draw_solid_utf8(surface, "#{steps} steps", 0, 20, 0xff, 0xff, 0xff)
    font.draw_solid_utf8(surface, "Last reward: #{robot.last_reward}", 0, 40, 0xff, 0xff, 0xff)
    font.draw_solid_utf8(surface, "Mode: #{mode}", 0, 60, 0xff, 0xff, 0xff)

    surface.flip
    fps_counter.tick
    #SDL.delay(16)
  end
end

SDL.quit
