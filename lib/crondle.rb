$:.unshift File.dirname(__FILE__)

require 'crondle/builder'
require 'crondle/job'

module Crondle
  def self.define_jobs(&block)
    builder = Builder.new
    yield builder
    puts builder.jobs.join("\n\n")
  end
end
