class CronTabBuilder

  def desc(desc)
    @next_desc = desc 
  end

  def job(cmd, options)
    self.jobs << CronJob.new(next_desc, cmd, options)
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


class CronJob
  attr_accessor :minute,
                :hour,
                :day_of_month,
                :month,
                :day_of_week,
                :description,
                :cmd

  def initialize(description, cmd, options)
    self.description = description
    self.cmd = cmd
    set_options(options)
  end

  def set_options(options)
    self.minute = options[:minute] || "*"
    self.hour = options[:hour] || "*"
    self.day_of_month = options[:day_of_month] || "*"
    self.month = options[:month] || "*"
    self.day_of_week = options[:day_of_week] || "*"
  end

  def to_s
    "# #{description}\n #{minute} #{hour} #{day_of_month} #{month} #{day_of_week} #{cmd}"
  end

end

