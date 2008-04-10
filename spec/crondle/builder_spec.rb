require File.dirname(__FILE__) + '/../spec_helper.rb'

module Crondle
  describe Builder do
    it "should start off with no jobs" do
      Builder.new.jobs.size.should equal(0)
    end

    it "should have another Job after #job is called" do
      b = Builder.new
      b.job("ls")
      b.jobs.size.should equal(1)
    end

    it "should return an empty array if there are no jobs" do
      Builder.new.jobs.should eql([])
    end

    it "should pass the #job args thru to the newly created Job" do
      b = Builder.new
      b.job("ls", :minute => 1, :hour => 2, :day_of_month => 3, :month => 4, :day_of_week => :tuesday)
      j = b.jobs.last
      j.minute.should eql(1)
      j.hour.should eql(2)
      j.day_of_month.should eql(3)
      j.month.should eql(4)
      j.day_of_week.should eql(2)
      j.cmd.should eql("ls")
    end

    it "should use the set description for all subsequent jobs till another is set" do
      b = Builder.new

      b.desc "test"
      j = b.job("ls")
      j.description.should eql("test")
      j = b.job("ls -l")
      j.description.should eql("test")

      b.desc "foo"
      j = b.job("ls -lh")
      j.description.should eql("foo")
    end

    it "should return the new Job when #job is called" do
      b = Builder.new
      b.job("ls")
      b.job("ls -l")
      j = b.job("ls -h")
      j.should be_a_kind_of(Job)
      j.cmd.should eql("ls -h")
    end

    it "should return a Job when #daily_job is called" do
      Builder.new.daily_job("ls").should be_a_kind_of(Job)
    end

    it "should run jobs created with #daily_job every midnight by default" do
      j = Builder.new.daily_job("ls")
      j.hour.should equal(0)
      j.minute.should equal(0)
    end

    it "should apply the #with_options options to the Jobs defined in the #with_options block" do
      b = Builder.new
      b.with_options :month => 3 do
        b.job("ls")
      end
      b.jobs.first.month.should eql(3)
    end

    it "should reset the carry over options once the #with_options block has ended" do
      b = Builder.new
      b.with_options :month => 3 do
      end
      b.job("ls")
      b.jobs.first.month.should_not be
    end

  end
end
