class FPSCounter
  attr_reader :fps

  def initialize
    @fps = 0.0
    @prev_time = Time.now.to_f
    @count = 0
  end

  def tick
    @count += 1
    cur = Time.now.to_f
    if cur - @prev_time >= 1
      @fps = @count / (cur-@prev_time)
      @prev_time = cur
      @count = 0
    end
  end
end
