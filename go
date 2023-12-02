#! /usr/bin/env ruby

day, level = ARGV
raise "gotta tell me which day!" unless day
level ||= 'test'

require_relative 'tools'
require_relative "./#{day}/main"

Solutions.send(level.to_sym)
