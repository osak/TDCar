class Sarsa
  ALPHA = 0.1
  GAMMA = 0.4
  EPSILON = 0.01

  def initialize(init_state)
    @hoge = {}
    @qs = Hash.new{|h,k| h[k] = 0.0}
    reset(init_state)
  end

  def save_q(filename)
    File.open(filename, "w") do |f|
      Marshal.dump(@qs.to_a, f)
    end
    puts "Saved #{filename}"
  end

  def load_q(filename)
    File.open(filename) do |f|
      Marshal.load(f).each do |elem|
        @qs[elem[0]] = elem[1]
      end
    end
    puts "Loaded #{filename}"
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
    reward, ns = @cur.next_state(@action)
    na = decide(ns)
    key = [@cur,@action]
    #puts key.join(' ')

    @qs[key] += ALPHA * (reward + GAMMA*@qs[[ns,na]] - @qs[key])
    @cur = ns
    @action = na
  end

  def reset(state)
    @cur = state
    @action = decide(@cur)
  end

  def do_episode(max_step = 100)
    cur = State.new(0, 0)

    action = decide(cur)
    max_step.times do
      reward, ns = cur.next_state(action)
      na = decide(ns)
      key = [cur,action]

      @qs[key] += ALPHA * (reward + GAMMA*@qs[[ns,na]] - @qs[key])
      cur = ns
      action = na
      if cur.terminal?
        #puts "terminal"
        break
      end
    end
  end
end
