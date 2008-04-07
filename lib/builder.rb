class Builder

  def desc(desc)
    @next_desc = desc 
  end

  def job(cmd, options)
    self.jobs << Job.new(next_desc, cmd, options)
  end

  def daily_job(cmd, hour = 0, minute = 0)
    self.jobs << Job.new(next_desc, cmd, :hour => hour, :minute => 0)
  end

  def self.define_jobs(&block)
    yield instance
    puts instance.jobs.join("\n\n")
  end

  def self.instance
    @instance ||= new
  end

  def jobs
    @jobs ||= []
  end

  private
  def initialize
  end

  def next_desc
    @next_desc || ""
  end
end
