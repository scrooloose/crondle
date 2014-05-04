require File.dirname(__FILE__) + '/../spec_helper.rb'

module Crondle
  describe Job do
    it "should not allow 'minute' to be < 0" do
      lambda {Job.new("desc", "ls", :minute => -1)}.should raise_error(Job::InvalidTimingParamError)
    end

    it "should not allow 'minute' to be > 60" do
      lambda {Job.new("desc", "ls", :minute => 61)}.should raise_error(Job::InvalidTimingParamError)
    end

    it "should not allow 'hour' to be > 23" do
      lambda {Job.new("desc", "ls", :hour => 24)}.should raise_error(Job::InvalidTimingParamError)
    end

    it "should not allow 'hour' to be < 0" do
      lambda {Job.new("desc", "ls", :hour => -1)}.should raise_error(Job::InvalidTimingParamError)
    end

    it "should not allow 'day_of_month' to be > 31" do
      lambda {Job.new("desc", "ls", :day_of_month => 32)}.should raise_error(Job::InvalidTimingParamError)
    end

    it "should not allow 'day_of_month' to be < 0" do
      lambda {Job.new("desc", "ls", :day_of_month => -1)}.should raise_error(Job::InvalidTimingParamError)
    end

    it "should not allow 'month' to be < 0" do
      lambda {Job.new("desc", "ls", :month => -1)}.should raise_error(Job::InvalidTimingParamError)
    end

    it "should not allow 'month' to be > 12" do
      lambda {Job.new("desc", "ls", :month => 13)}.should raise_error(Job::InvalidTimingParamError)
    end

    it "should not allow 'day_of_week' to be something other than :monday||:tuesday||:wednesday||etc" do
      lambda {Job.new("desc", "ls", :day_of_week => :foobarday)}.should raise_error(Job::InvalidTimingParamError)
    end

    it "should allow 'day_of_week' to be :monday||:tuesday||:wednesday||etc" do
      lambda {Job.new("desc", "ls", :day_of_week => :monday)}.should_not    raise_error
      lambda {Job.new("desc", "ls", :day_of_week => :tuesday)}.should_not   raise_error
      lambda {Job.new("desc", "ls", :day_of_week => :wednesday)}.should_not raise_error
      lambda {Job.new("desc", "ls", :day_of_week => :thursday)}.should_not  raise_error
      lambda {Job.new("desc", "ls", :day_of_week => :friday)}.should_not    raise_error
      lambda {Job.new("desc", "ls", :day_of_week => :saturday)}.should_not  raise_error
      lambda {Job.new("desc", "ls", :day_of_week => :sunday)}.should_not    raise_error
    end

    it "should default all timing options to '*' if they arent specified" do
      Job.new("desc", "ls", {}).to_s.count("*").should equal(5)
    end

    it "should allow only 2 arguments" do
      Job.new("desc", "ls").to_s.count("*").should equal(5)
    end

    it "should work if day_of_week is a symbol OR a string" do
      lambda {Job.new("desc", "ls", :day_of_week => :monday)}.should_not  raise_error
      lambda {Job.new("desc", "ls", :day_of_week => 'monday')}.should_not raise_error
    end

    it "should output the description as a comment on the first line and the crontab command on the following line" do
      j = Job.new("desc", "ls", :hour => 10, :minute => 22)
      j.to_s.should match(/^# desc\n.*$/)
    end

    it "should output the timing params in the right order" do
      j = Job.new("desc", "ls", :minute => 1, :hour => 2, :day_of_month => 3, :month => 4, :day_of_week => :friday)
      j.to_s.should match(/^.*\n1 2 3 4 5.*$/)
    end

    it "should output the command on the end of the second line" do
      j = Job.new("desc", "ls", :minute => 1, :hour => 2, :day_of_month => 3, :month => 4, :day_of_week => :friday)
      j.to_s.should match(/^.*\n.*ls$/)
    end
  end
end
