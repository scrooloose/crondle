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
  class InvalidTimingParamError < StandardError; end


  attr_reader :minute,
              :hour,
              :day_of_month,
              :month,
              :day_of_week

  attr_accessor :description,
                :cmd

  def initialize(description, cmd, timing_options)
    self.description = description
    self.cmd = cmd
    set_timing_options(timing_options)
  end

  def set_timing_options(options)
    self.minute = options[:minute] || "*"
    self.hour = options[:hour] || "*"
    self.day_of_month = options[:day_of_month] || "*"
    self.month = options[:month] || "*"
    self.day_of_week = options[:day_of_week] || "*"
  end

  def minute=(minute)
    unless (0..59).include?(minute) || minute == "*"
      raise(InvalidTimingParamError, "Minute must be * or fall in the range 0..59") 
    end
    @minute = minute
  end

  def hour=(hour)
    unless (0..23).include?(hour) || hour == "*"
      raise(InvalidTimingParamError, "Hour must be * or fall in the range 0..23") 
    end
    @hour = hour
  end

  def day_of_month=(day_of_month)
    unless (0..31).include?(day_of_month) || day_of_month == "*"
      raise(InvalidTimingParamError, "Day of month must be * or fall in the range 0..31")
    end
    @day_of_month = day_of_month
  end

  def month=(month)
    unless (1..12).include?(month) || month == "*"
      raise(InvalidTimingParamError, "Month must be * or fall in the range 1..12") 
    end
    @month = month
  end

  def day_of_week=(day_of_week)
    @day_of_week = case day_of_week
                   when :sunday:    0
                   when :monday:    1
                   when :tuesday:   2
                   when :wednesday: 3
                   when :thursday:  4
                   when :friday:    5
                   when :saturday:  6
                   when "*":        "*"
                   else
                     raise(InvalidTimingParamError, "Day of week must be * or one of :monday, :tuesday, etc")
                   end
  end

  def to_s
    "# #{description}\n #{minute} #{hour} #{day_of_month} #{month} #{day_of_week} #{cmd}"
  end

end

