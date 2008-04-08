module Crondle
  class Builder

    def desc(desc)
      @next_desc = desc 
    end

    def job(cmd, options = {})
      jobs << Job.new(next_desc, cmd, options)
    end

    def daily_job(cmd, hour = 0, minute = 0)
      job(cmd, :hour => hour, :minute => 0)
    end

    def jobs
      @jobs ||= []
    end

    private
    def next_desc
      @next_desc || ""
    end
  end
end
