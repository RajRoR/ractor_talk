# Define the first Ractor
ractor1 = Ractor.new do
  loop do
    # Wait to receive a message
    message = Ractor.receive
    puts "Ractor 1 received: #{message}"
    break if message == 'END'

    # Process the message and send a response back
    response = "Ractor 1 processed: #{message}"
    Ractor.yield(response)
  end
end

# Define the second Ractor
ractor2 = Ractor.new(ractor1) do |r1|
  messages = ['Hello', 'How are you?', 'Goodbye', 'END']
  responses = []

  messages.each do |msg|
    puts "Ractor 2 sending: #{msg}"
    r1.send(msg)
    break if msg == 'END'

    # Receive the response from ractor1
    response = r1.take
    responses << response
    puts "Ractor 2 received response: #{response}"
    puts '-----------------------'
  end

  responses
end

# Wait for ractor2 to finish and get the responses
responses = ractor2.take
puts '*********************************************'
puts "Responses received by Ractor 2: #{responses.inspect}"
