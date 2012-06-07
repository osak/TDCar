require_relative 'problem'

class QLearning
  ALPHA = 0.1
  GAMMA = 0.9
  EPSILON = 0.05

  def initialize(init_state)
    @qs = Hash.new{|h,k| h[k] = 0.0}
    @cur = init_state
  end

  def greedy_decide(state)
    max_q = -Float::INFINITY
    best = nil
    Action.each do |action|
      key = [state,action]
      if @qs[key] > max_q
        max_q = @qs[key]
        best = action
      end
    end
    best
  end

  def decide(state)
    if rand < EPSILON
      # random walk
      Action.all.sample
    else
      greedy_decide(state)
    end
  end

  def do_step
    action = decide(@cur)
    reward, ns = @cur.next_state(action)
    key = [@cur, action]
    max_q = -Float::INFINITY
    Action.each do |a|
      max_q = [max_q, @qs[[ns,a]]].max
    end
    @qs[key] += ALPHA * (reward + GAMMA*max_q - @qs[key])
    @cur = ns
  end

  def reset(state)
    @cur = state
  end

  def do_episode(max_step = 100)
    cur = State.new(0, 0)

    max_step.times do
      action = decide(cur)
      reward, ns = cur.next_state(action)
      key = [cur,action]

      max_q = -Float::INFINITY
      Action.each do |a|
        max_q = [max_q, @qs[[ns,a]]].max
      end
      @qs[key] += ALPHA * (reward + GAMMA*max_q - @qs[key])
      cur = ns
      if cur.terminal?
        #puts "terminal"
        break
      end
    end
  end
end

