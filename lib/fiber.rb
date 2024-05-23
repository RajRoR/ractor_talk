# frozen_string_literal: true

require 'colorize'
require 'benchmark'
require 'fiber'

counter, half_counter = 0, 0

# Helper method to simulate async sleep
def fiber_yield(duration)
  start = Time.now
  Fiber.yield while Time.now - start < duration
end

# Method to run fiber tasks
def run_fibers(*fibers)
  fibers.each { |fiber| fiber.resume if fiber.alive? } while fibers.any? { |fiber| fiber.alive? }
end

fiber1 = Fiber.new do
  20.times do
    counter += 1
    sleep(0.1)
    half_counter += 1 if counter.odd?
    puts "Counter: #{counter}, Half Counter: #{half_counter}".colorize(:yellow)

    fiber_yield(0.1)
  end
end

fiber2 = Fiber.new do
  20.times do
    counter += 1
    sleep(0.1)
    half_counter += 1 if counter.odd?
    puts "Counter: #{counter}, Half Counter: #{half_counter}"

    fiber_yield(0.1)
  end
end

time_fiber = Benchmark.realtime do
  run_fibers(fiber1, fiber2)
end

puts '------------------------------------------------------'
puts "Counter: #{counter}".colorize(:green)
puts "Half Counter: #{half_counter}".colorize(:green)
puts "Time taken for Fiber tasks: #{time_fiber} seconds".colorize(:green)
