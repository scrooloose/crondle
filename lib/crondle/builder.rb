module Crondle
  class Builder
    def desc(desc)
      @next_desc = desc 
    end

    def job(cmd, options = {})
      j = Job.new(next_desc, cmd, carry_over_options.merge(options))
      jobs << j
      j
    end

    def daily_job(cmd, hour = 0, minute = 0)
      job(cmd, :hour => hour, :minute => 0)
    end

    def jobs
      @jobs ||= []
    end

    def with_options(options, &block)
      @carry_over_options = options
      yield self
      @carry_over_options.clear
    end

    private
    def next_desc
      @next_desc || ""
    end

    def carry_over_options
      @carry_over_options || {}
    end

  end
end
