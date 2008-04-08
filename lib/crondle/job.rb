module Crondle
  class Job
    class InvalidTimingParamError < StandardError; end

    attr_reader :minute,
      :hour,
      :day_of_month,
      :month,
      :day_of_week

    attr_accessor :description,
      :cmd

    def initialize(description, cmd, timing_options = {})
      self.description = description
      self.cmd = cmd
      set_timing_options(timing_options)
    end

    def set_timing_options(options)
      self.minute = options[:minute] if options[:minute]
      self.hour = options[:hour] if options[:hour]
      self.day_of_month = options[:day_of_month] if options[:day_of_month]
      self.month = options[:month] if options[:month]
      self.day_of_week = options[:day_of_week].to_sym if options[:day_of_week]
    end

    def minute=(minute)
      raise(InvalidTimingParamError, "Minute must be in the range 0..59") unless (0..59).include?(minute)
      @minute = minute
    end

    def hour=(hour)
      raise(InvalidTimingParamError, "Hour must be in the range 0..23") unless (0..23).include?(hour)
      @hour = hour
    end

    def day_of_month=(day_of_month)
      raise(InvalidTimingParamError, "Day of month must be in the range 0..31") unless (0..31).include?(day_of_month)
      @day_of_month = day_of_month
    end

    def month=(month)
      raise(InvalidTimingParamError, "Month must be in the range 1..12") unless (1..12).include?(month)
      @month = month
    end

    def day_of_week=(day_of_week)
      @day_of_week = case day_of_week.to_sym
                     when :sunday:    0
                     when :monday:    1
                     when :tuesday:   2
                     when :wednesday: 3
                     when :thursday:  4
                     when :friday:    5
                     when :saturday:  6
                     else
                       raise(InvalidTimingParamError, "Day of week must be one of :monday, :tuesday, etc")
                     end
    end

    def to_s
      "# #{description}\n#{minute || "*"} #{hour || "*"} #{day_of_month || "*"} #{month || "*"} #{day_of_week || "*"} #{cmd}"
    end
  end
end
