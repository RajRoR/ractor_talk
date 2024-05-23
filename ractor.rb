# frozen_string_literal: true

require 'colorize'
require 'benchmark'

NUMBER_TO_CALCULATE, NUM = 30, 10

def fibonacci(n)
  return n if n < 1

  fibonacci(n - 1) + fibonacci(n - 2)
end

# Using Ractors
ractor_time = Benchmark.realtime do
  ractors = NUM.times.map do
    Ractor.new do
      fibonacci(NUMBER_TO_CALCULATE)
    end
  end

  ractors.each(&:take)
end

puts "Time taken for Ractor tasks: #{ractor_time} seconds".colorize(:green)

# Sequential Execution
sequential_time = Benchmark.realtime do
  NUM.times do
    fibonacci(NUMBER_TO_CALCULATE)
  end
end

puts "Time taken for Sequential tasks: #{sequential_time} seconds".colorize(:red)
