# frozen_string_literal: true

require 'colorize'
require 'benchmark'

counter, half_counter = 0, 0

time_threads = Benchmark.realtime do
  t1 = Thread.start do
    20.times do
      counter += 1
      sleep(0.1)
      half_counter += 1 if counter.odd?
      puts "Counter: #{counter}, Half Counter: #{half_counter}".colorize(:yellow)
    end
  end

  t2 = Thread.start do
    20.times do
      counter += 1
      sleep(0.1)
      half_counter += 1 if counter.odd?
      puts "Counter: #{counter}, Half Counter: #{half_counter}"
    end
  end

  t1.join
  t2.join
end

puts '------------------------------------------------------'
puts "Counter: #{counter}".colorize(:green)
puts "Half Counter: #{half_counter}".colorize(:red)
puts "Time taken for Thread tasks: #{time_threads} seconds"
