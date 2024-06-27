# frozen_string_literal: true

require 'colorize'
require 'benchmark'
require 'async'

# Method to calculate Fibonacci number
def fibonacci(n)
  return n if n <= 1

  fib = [0, 1]
  (2..n).each do |i|
    fib[i] = fib[i - 1] + fib[i - 2]
  end

  fib[n]
end

# Method to calculate sum of Fibonacci series using async gem
def sum_of_fibonacci_async(n)
  Async do |task|
    sum = 0

    # Spawn async tasks to calculate Fibonacci numbers concurrently
    (0..n).each do |i|
      task.async do
        sum += fibonacci(i)
      end
    end

    # Wait for all tasks to complete
    task.children.each(&:wait)

    puts "Sum of Fibonacci series up to #{n}: #{sum}"
  end
end

async_fibonacci_time = Benchmark.realtime { sum_of_fibonacci_async(30) }
puts "Time taken for Async tasks: #{async_fibonacci_time} seconds".colorize(:yellow)
