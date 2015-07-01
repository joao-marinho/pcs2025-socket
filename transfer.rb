require 'java'
require 'ring_buffer'
java_import 'java.util.concurrent.Semaphore'

class Transfer

  def initialize(source, destination, buffer_size = 1, n_bytes = 1)
    @source = source
    @destination = destination
    @n_bytes = n_bytes

    @buf = RingBuffer.new(buffer_size)
    @mutex = Mutex.new
    @empty_sem = Semaphore.new(buffer_size)
    @full_sem = Semaphore.new(0)
    @done = false
    @item = nil
  end

  def run
    consumer = Thread.new do
      while !@done || !@buf.empty? do
        @full_sem.acquire
        @mutex.synchronize do
          @item = @buf.shift
        end
        @empty_sem.release
        @destination.write @item
      end
      puts "Acabou de transferir"
    end

    producer = Thread.new do
      next_block = @source.read(@n_bytes)
      while !@done do
        @empty_sem.acquire
        @mutex.synchronize do
          @buf.push(next_block)
          next_block = @source.read(@n_bytes)
          @done = true if next_block.nil?    
        end
        @full_sem.release
      end
      puts "Acabou de ler"
    end

    producer.join
    consumer.join
  end
end