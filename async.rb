require 'colorize'
require 'benchmark'
require 'async'

def async_sleep(duration)
  start = Time.now
  Async { |task| task.sleep(duration - (Time.now - start)) }
end

def run_async_tasks(counter, half_counter, mutex)
  Async do |task|
    task.async do
      20.times do
        mutex.synchronize do
          counter += 1
          sleep(0.1)
          half_counter += 1 if counter.odd?
          puts "Counter: #{counter}, Half Counter: #{half_counter}".colorize(:yellow)
        end
        async_sleep(0.1)
      end
    end

    task.async do
      20.times do
        mutex.synchronize do
          counter += 1
          sleep(0.1)
          half_counter += 1 if counter.odd?
          puts "Counter: #{counter}, Half Counter: #{half_counter}"
        end
        async_sleep(0.1)
      end
    end
  end

  [counter, half_counter]
end

counter, half_counter = 0, 0
mutex = Mutex.new

time_async = Benchmark.realtime do
  counter, half_counter = run_async_tasks(counter, half_counter, mutex)
end

puts '------------------------------------------------------'
puts "Counter: #{counter}".colorize(:green)
puts "Half Counter: #{half_counter}".colorize(:green)
puts "Time taken for Async tasks: #{time_async} seconds".colorize(:green)
